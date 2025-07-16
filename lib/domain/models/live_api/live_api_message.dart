import 'package:freezed_annotation/freezed_annotation.dart';

enum Modality {
  text,
  image,
  audio
}

class PreBuiltVoiceConfig {
  String voice;

  PreBuiltVoiceConfig({
    required this.voice
  });
}

class VoiceConfig {
  PreBuiltVoiceConfig? preBuiltVoiceConfig;

  VoiceConfig({
    this.preBuiltVoiceConfig,
  });
}

class SpeechConfig {
  VoiceConfig? voiceConfig;
  String? languageCode;

  SpeechConfig({
    this.voiceConfig,
    this.languageCode
  });
}

class GenerationConfig {
  List<Modality>? responseModalities;
  int? maxOutputTokens;
  int? temperature;
  int? topP;
  int? topK;
  SpeechConfig? speechConfig;

  GenerationConfig({
    this.responseModalities = const [Modality.audio],
    this.maxOutputTokens = 4096,
    this.temperature,
    this.topP,
    this.topK,
    this.speechConfig
  });
}

class BidiGenerateContentSetup {
  String model;
  GenerationConfig? generationConfig;
  String? systemInstruction;
  List<LiveApiTool> tools;
}

@JsonSerializable()
class LiveApiMessage {
  dynamic setup;
  dynamic clientContent;
  dynamic realtimeInput;
  dynamic toolResponse;
}