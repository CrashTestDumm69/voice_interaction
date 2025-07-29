import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:voice_interaction/data/repositories/gemini_tts_repository.dart';

part 'tts_event.dart';
part 'tts_state.dart';

class TtsViewModel extends Bloc<TtsEvent, TtsState> {
  final GeminiTtsRepository _geminiTtsRepository;

  TtsViewModel({
    required GeminiTtsRepository geminiTtsRepository
  }) : _geminiTtsRepository = geminiTtsRepository,
       super(TtsInitial()) {
    on<LoadTtsFiles>((event, emit) async {
      emit(TtsLoading());
      try {
        emit(TtsLoaded(List.from(_geminiTtsRepository.speechFiles)));
      } catch (e) {
        emit(TtsError("Failed to load TTS files: ${e.toString()}"));
      }
    });

    on<GenerateSpeech>((event, emit) async {
      emit(TtsLoading());
      try {
        await _geminiTtsRepository.generateAndSpeech(text: event.text, name: event.name);
        emit(TtsLoaded(List.from(_geminiTtsRepository.speechFiles)));
      } catch (e) {
        emit(TtsError("Failed to generate speech: ${e.toString()}"));
      }
    });

    on<DeleteSpeech>((event, emit) async {
      emit(TtsLoading());
      try {
        await _geminiTtsRepository.deleteSpeech(event.file);
        emit(TtsLoaded(List.from(_geminiTtsRepository.speechFiles)));
      } catch (e) {
        emit(TtsError("Failed to delete speech: ${e.toString()}"));
      }
    });
  }
}
