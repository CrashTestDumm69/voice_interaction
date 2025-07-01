import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:rive/rive.dart' show StateMachineController, SMITrigger, SMIBool, RiveAnimation, Artboard ;
import 'package:voice_interaction/ui/core/animated_overlay.dart';

import 'package:voice_interaction/ui/features/interaction/view_model/interaction_view_model.dart';

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

  void _onRiveInit(Artboard artboard) {
    _riveController = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
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
  void dispose() {
    widget.viewModel.add(EndSession());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InteractionViewModel, InteractionState>(
      bloc: widget.viewModel,
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
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (state is InteractionDisconnected || state is InteractionInitial) { 
                      widget.viewModel.add(StartSession());
                    }
                  },
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: RiveAnimation.asset(
                      'assets/mic.riv',
                      fit: BoxFit.contain,
                      onInit: _onRiveInit,
                    ),
                  ),
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
                        heroTag: 'toggle_volume_slider',
                        backgroundColor: Colors.grey.shade800,
                        child: Icon(Icons.volume_up, color: Colors.white),
                        onPressed: () {
                          widget.viewModel.add(VolumeChangePressed());
                        }
                      ),
                      const Gap(16),
                      FloatingActionButton(
                        heroTag: 'mic_toggle',
                        backgroundColor: state.micMuted ? Colors.red : Colors.green,
                        child: Icon(
                          state.micMuted ? Icons.mic_off : Icons.mic,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (state.micMuted) {
                            widget.viewModel.add(UnmuteMic());
                          } else {
                            widget.viewModel.add(MuteMic());
                          }
                        },
                      ),
                      const Gap(16),
                      FloatingActionButton(
                        heroTag: 'end_session',
                        backgroundColor: Colors.grey.shade800,
                        child: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          widget.viewModel.add(EndSession());
                        },
                      ),
                    ],
                  ),
                ),
              AnimatedOverlay(
                condition: state is InteractionConnecting,
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
