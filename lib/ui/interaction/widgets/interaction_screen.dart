import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:rive/rive.dart';

import 'package:voice_interaction/ui/interaction/view_model/interaction_view_model.dart';
import 'package:voice_interaction/ui/interaction/widgets/department_details_widget.dart';
import 'package:voice_interaction/ui/interaction/widgets/language_selection_widget.dart';
import 'package:voice_interaction/ui/interaction/widgets/package_details_widget.dart';
import 'package:voice_interaction/ui/models/department_details.dart';
import 'package:voice_interaction/ui/models/package_detials.dart';
import 'package:voice_interaction/utils/injection_container.dart';

class InteractionScreen extends StatefulWidget {
  final InteractionViewModel viewModel;
  const InteractionScreen({super.key, required this.viewModel});

  @override
  State<InteractionScreen> createState() => _InteractionScreenState();
}

class _InteractionScreenState extends State<InteractionScreen> {
  StateMachineController? _riveController;
  SMITrigger? _listenTrigger;
  SMITrigger? _speakTrigger;
  SMIBool? _idleBool;

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

  void _onRiveInit(Artboard artboard) {
    _riveController = StateMachineController.fromArtboard(
      artboard,
      'State Machine (robot speaks)',
    );

    if (_riveController != null) {
      artboard.addController(_riveController!);
      _listenTrigger = _riveController!.getTriggerInput('listen');
      _speakTrigger = _riveController!.getTriggerInput('speak');
      _idleBool = _riveController!.getBoolInput('idle');
    }
  }

  void _setRiveBool(SMIBool? input, bool value) {
    input?.change(value);
  }

  void _handleRiveTrigger(SMITrigger? trigger) {
    trigger?.fire();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InteractionViewModel, InteractionState>(
      bloc: sl<InteractionViewModel>(),
      listener: (context, state) {
        if (state is InteractionConnected) {
          _setRiveBool(_idleBool, false);
          if (state.speechState == InteractionSpeechState.listening) {
            _handleRiveTrigger(_listenTrigger);
          } else if (state.speechState == InteractionSpeechState.speaking) {
            _handleRiveTrigger(_speakTrigger);
          }
        } else if (state is InteractionConnecting || state is InteractionDisconnected) {
          _handleRiveTrigger(_listenTrigger);
          _setRiveBool(_idleBool, true);
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
                onInit: _onRiveInit,
              ),
            ),
            if (state is InteractionConnected)
              Stack(
                children: [
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
                        const Gap(16),
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
                  if (state.details != null)
                    if (state.details is DepartmentDetails)
                      DepartmentDetailsWidget(department: state.details as DepartmentDetails, onDone: () => sl<InteractionViewModel>().add(CloseDetails()))
                    else if (state.details is PackageDetials)
                      PackageDetailsWidget(package: state.details as PackageDetials, onDone: () => sl<InteractionViewModel>().add(CloseDetails()))
                ],
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
