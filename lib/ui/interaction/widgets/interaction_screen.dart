import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rive/rive.dart';

import 'package:voice_interaction/domain/models/health_package.dart';
import 'package:voice_interaction/data/services/realtime_api_service.dart';
import 'package:voice_interaction/ui/interaction/view_model/interaction_view_model.dart';
import 'package:voice_interaction/ui/interaction/widgets/language_selection_widget.dart';
import 'package:voice_interaction/utils/injection_container.dart';

class InteractionScreen extends StatefulWidget {
  final InteractionViewModel viewModel;
  const InteractionScreen({super.key, required this.viewModel});

  @override
  State<InteractionScreen> createState() => _InteractionScreenState();
}

class _InteractionScreenState extends State<InteractionScreen> {
  HealthPackage? packageDetails;
  SpeechState speechState = SpeechState.idle;
  StateMachineController? controller;
  SMITrigger? listenTrigger;
  SMITrigger? speakTrigger;
  SMITrigger? idleTrigger;

  @override
  void initState() {
    super.initState();
  }

  void _showLanguageDialog() async {
    final selectedLanguage = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => LanguageSelectionWidget(),
    );

    if (selectedLanguage != null) {
      sl<InteractionViewModel>().add(StartSession(instruction: selectedLanguage));
    }
  }

  void onRiveInit(Artboard artboard) {
    controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine (robot speaks)',
    );

    if (controller != null) {
      artboard.addController(controller!);
      listenTrigger = controller!.getTriggerInput('listen');
      speakTrigger = controller!.getTriggerInput('speak');
      idleTrigger = controller!.getTriggerInput('idle');
    }
  }

  void _handleTrigger(SMITrigger? trigger) {
    trigger?.fire();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InteractionViewModel, InteractionState>(
      bloc: sl<InteractionViewModel>(),
      listener: (context, state) {
        if (state is InteractionConnected) {
          if (state.speechState == SpeechState.listening) {
            _handleTrigger(listenTrigger);
          } else if (state.speechState == SpeechState.speaking) {
            _handleTrigger(speakTrigger);
          }
        } else if (state is InteractionConnecting || state is InteractionDisconnected) {
          _handleTrigger(listenTrigger);
          Future.delayed(const Duration(milliseconds: 300), () => _handleTrigger(idleTrigger));
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            GestureDetector(
              onDoubleTap: () {
                if (state is InteractionDisconnected || state is InteractionInitial) { 
                  _showLanguageDialog();
                }
              },
              child: RiveAnimation.asset(
                'assets/face.riv',
                fit: BoxFit.contain,
                onInit: onRiveInit,
              ),
            ),
            if (state is InteractionConnected)
              Positioned(
                bottom: 40,
                right: 40,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      heroTag: 'mic_toggle',
                      backgroundColor: state.micMuted ? Colors.red : Colors.green,
                      child: Icon(
                        state.micMuted ? Icons.mic_off : Icons.mic,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (state.micMuted) {
                          sl<InteractionViewModel>().add(UnmuteMic());
                        } else {
                          sl<InteractionViewModel>().add(MuteMic());
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    FloatingActionButton(
                      heroTag: 'end_session',
                      backgroundColor: Colors.grey[800],
                      child: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        sl<InteractionViewModel>().add(EndSession());
                      },
                    ),
                  ],
                ),
              ),
            if (state is InteractionConnecting)
              Positioned.fill(
                child: Container(
                 color: Colors.black.withValues(alpha: 0.8),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      }
    );
  }
}
