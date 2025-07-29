import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import 'package:voice_interaction/data/services/dotenv_service.dart';
import 'package:voice_interaction/data/services/gemini_tts_service.dart';

class GeminiTtsRepository {
  final GeminiTtsService _geminiTtsService;
  final DotenvService _dotenvService;

  late final String _speechFileStoragePath;

  List<File> _speechFiles = [];
  List<File> get speechFiles => _speechFiles;

  GeminiTtsRepository({
    required GeminiTtsService geminiTtsService,
    required DotenvService dotenvService
  }) : _geminiTtsService = geminiTtsService,
       _dotenvService = dotenvService;

  Future<void> init() async {
    final path = await getApplicationSupportDirectory();
    _speechFileStoragePath = "${path.path}/audio_files";

    final dir = Directory(_speechFileStoragePath);
    if (!dir.existsSync()) {
      dir.createSync();
    }

    _speechFiles = dir.listSync().whereType<File>().toList();
    
  }

  Future<void> generateAndSpeech({required String text, required String name}) async {
    final audio = await _geminiTtsService.convertToSpeech(apiKey: _dotenvService.getApiKey(), text: text);
    
    throwIf(audio == null, "Speech generation failed");

    final filePath = "$_speechFileStoragePath/$name.wav";
    await File(filePath).writeAsBytes(audio!);
    _speechFiles = Directory(_speechFileStoragePath).listSync().whereType<File>().toList();
  }

  Future<void> deleteSpeech(File file) async {
    if (file.existsSync()) file.deleteSync();
    _speechFiles = Directory(_speechFileStoragePath).listSync().whereType<File>().toList();
  }
}