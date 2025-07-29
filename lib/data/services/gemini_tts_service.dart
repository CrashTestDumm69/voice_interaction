import 'package:dio/dio.dart';
import 'package:voice_interaction/domain/models/gemini_api_common_types/content/content.dart';

class GeminiTtsService {
  final Dio _dio;

  GeminiTtsService({required Dio dio}) : _dio = dio;
}
