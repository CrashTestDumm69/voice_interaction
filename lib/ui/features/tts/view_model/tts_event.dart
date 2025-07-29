part of 'tts_view_model.dart';

abstract class TtsEvent {}

class LoadTtsFiles extends TtsEvent {}

class GenerateSpeech extends TtsEvent {
  final String text;
  final String name;

  GenerateSpeech({required this.text, required this.name});
}

class DeleteSpeech extends TtsEvent {
  final File file;

  DeleteSpeech(this.file);
}
