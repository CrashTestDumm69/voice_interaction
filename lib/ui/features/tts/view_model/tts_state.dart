part of 'tts_view_model.dart';

abstract class TtsState {}

class TtsInitial extends TtsState {}

class TtsLoading extends TtsState {}

class TtsLoaded extends TtsState {
  final List<File> speechFiles;

  TtsLoaded(this.speechFiles);
}

class TtsError extends TtsState {
  final String message;

  TtsError(this.message);
}
