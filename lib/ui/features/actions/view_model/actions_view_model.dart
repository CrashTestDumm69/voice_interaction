import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_interaction/data/repositories/ros_repository.dart';

part 'actions_event.dart';
part 'actions_state.dart';

class ActionsViewModel extends Bloc<ActionsEvent, ActionsState> {
  final RosRepository _rosRepository;

  List<String> _actions = [];

  ActionsViewModel({
    required RosRepository rosRepository,
  }) : _rosRepository = rosRepository,
       super(ActionsState(actions: [], error: null)) {
    
    _rosRepository.armActionsStream.listen((data) {
      add(UpdateArmActions(actions: data));
    });

    on<UpdateArmActions>((event, emit) {
      _actions = event.actions;
      emit(ActionsState(actions: _actions, error: null));
    });

    on<EmitError>((event, emit) {
      emit(ActionsState(actions: _actions, error: event.message));
    });

    on<SendArmAction>((event, emit) {
      try {
        _rosRepository.sendArmAction(event.action);
      } catch (e) {
        add(EmitError(e.toString()));
      }
    });
  }
}