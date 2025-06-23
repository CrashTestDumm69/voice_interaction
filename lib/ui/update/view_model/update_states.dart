part of 'update_view_model.dart';

abstract class UpdateState {}

class UpdateInitial extends UpdateState {}

class UpdateAvailable extends UpdateState {
  final String version;

  UpdateAvailable({required this.version});
}

class UpdateNotAvailable extends UpdateState {}

class UpdateInProgress extends UpdateState {
  final double? percent;

  UpdateInProgress({required this.percent});
}

class UpdateFailed extends UpdateState {
  final String message;

  UpdateFailed({required this.message});
}

class CheckingForUpdate extends UpdateState {}

class UpdateCompleted extends UpdateState {}