part of 'update_view_model.dart';

abstract class UpdateEvent {}

class CheckForUpdate extends UpdateEvent {}

class StartUpdateCheck extends UpdateEvent {}

class StopUpdateCheck extends UpdateEvent {}

class PerformUpdate extends UpdateEvent {}

class Updating extends UpdateEvent {
  final int progress;
  final int total;

  Updating({
    required this.progress,
    required this.total
  });
}