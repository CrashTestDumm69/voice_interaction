part of 'actions_view_model.dart';

abstract class ActionsEvent {}

class UpdateArmActions extends ActionsEvent {
  final List<String> actions;

  UpdateArmActions({required this.actions});
}

class SendArmAction extends ActionsEvent {
  final String action;

  SendArmAction({required this.action});
}

class EmitError extends ActionsEvent {
  final String message;

  EmitError(this.message);
}