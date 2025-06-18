part of 'update_view_model.dart';

abstract class UpdateState {}

class UpdateInitial extends UpdateState {}

class UpdateAvailable extends UpdateState {}

class UpdateNotAvailable extends UpdateState {}

class UpdateInProgress extends UpdateState {
  final int progress;
  final int total;

  UpdateInProgress({required this.progress, required this.total});
}