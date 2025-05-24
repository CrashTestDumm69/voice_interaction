import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:voice_interaction/data/models/health_package.dart';
import 'package:voice_interaction/data/services/realtime_api_service.dart';
import 'package:voice_interaction/ui/interaction/view_model/interaction_event.dart';
import 'package:voice_interaction/ui/interaction/view_model/interaction_state.dart';
import 'package:voice_interaction/ui/interaction/view_model/interaction_view_model.dart';
import 'package:voice_interaction/ui/interaction/widgets/language_selection_widget.dart';
import 'package:voice_interaction/ui/interaction/widgets/package_details_widget.dart';

class InteractionScreen extends StatefulWidget {
  const InteractionScreen({super.key});

  @override
  State<InteractionScreen> createState() => _InteractionScreenState();
}

class _InteractionScreenState extends State<InteractionScreen> {
  late final InteractionViewModel model;
  HealthPackage? packageDetails;
  SpeechState speechState = SpeechState.idle;
  StateMachineController? controller;
  SMITrigger? bringMic;
  SMITrigger? bringMouth;
  SMITrigger? stopMouth;
  SMITrigger? stillAgain;
  bool isMicMuted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model = context.read<InteractionViewModel>();
      model.add(InitializeEvent());
    });
  }

  void _showLanguageDialog(InteractionViewModel model) async {
    final selectedLanguage = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => LanguageSelectionWidget(),
    );

    if (selectedLanguage != null) {
      model.add(StartApiConnectionEvent(language: selectedLanguage));
    }
  }

  void onRiveInit(Artboard artboard) {
    controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine (robot speaks)',
    );

    if (controller != null) {
      artboard.addController(controller!);
      bringMic = controller!.getTriggerInput('bring mic');
      bringMouth = controller!.getTriggerInput('bring mouth');
      stopMouth = controller!.getTriggerInput('stop mouth');
      stillAgain = controller!.getTriggerInput('still again');
    }
  }

  void _handleTrigger(SMITrigger? trigger) {
    trigger?.fire();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InteractionViewModel, InteractionState>(
      listener: (context, state) {
        // debugPrint("State - ${state.speechState.toString()}");
        // debugPrint("Package - ${state.packageDetails.toString()}");
        if (state.speechState == SpeechState.idle) {
          if (speechState == SpeechState.speaking) {
            _handleTrigger(stopMouth);
          }
          _handleTrigger(stillAgain);
        } else if (state.speechState == SpeechState.listening) {
          if (speechState == SpeechState.speaking) {
            _handleTrigger(stopMouth);
          } else if (speechState == SpeechState.idle) {
            _handleTrigger(bringMic);
          }
        } else if (state.speechState == SpeechState.speaking) {
          _handleTrigger(bringMouth);
        }

        if (speechState != state.speechState) {
          setState(() {
            speechState = state.speechState;
          });
        }
        if (packageDetails != state.packageDetails) {
          setState(() {
            packageDetails = state.packageDetails;
          });
        }
        if (isMicMuted != state.isMicMuted) {
          setState(() {
            isMicMuted = state.isMicMuted;
          });
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            GestureDetector(
              onDoubleTap: () => _showLanguageDialog(model),
              child: RiveAnimation.asset(
                'assets/face.riv',
                fit: BoxFit.contain,
                onInit: onRiveInit,
              ),
            ),
            if (packageDetails != null)
              PackageDetailsWidget(
                data: packageDetails!.toJson(),
                onDone: () => model.add(ClosePackageDetailsEvent()),
              ),
            if (state.connectionState == RealtimeConnectionState.connecting)
              Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.8),
                child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
              ),
            if (state.connectionState == RealtimeConnectionState.connected)
              Positioned(
              bottom: 32,
              right: 32,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                FloatingActionButton(
                  heroTag: 'mic_toggle',
                  backgroundColor: isMicMuted
                    ? Colors.red
                    : Colors.green,
                  child: Icon(
                    isMicMuted
                    ? Icons.mic_off
                    : Icons.mic,
                  color: Colors.white,
                  ),
                  onPressed: () => model.add(ToggleMicrophoneEvent())
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  heroTag: 'end_session',
                  backgroundColor: Colors.grey[800],
                  child: const Icon(Icons.call_end, color: Colors.white),
                  onPressed: () {
                  model.add(EndApiSessionEvent());
                  },
                ),
                ],
              ),
              ),
          ],
        );
      },
    );
  }
}
