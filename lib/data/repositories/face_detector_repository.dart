import 'package:voice_interaction/data/services/face_detector_service.dart';

class FaceDetectorRepository {
  final FaceDetectorService _faceDetectorService;

  FaceDetectorRepository({required FaceDetectorService faceDetectorService})
      : _faceDetectorService = faceDetectorService;

  Future<void> init() async {
    try {
      await _faceDetectorService.initializeCamera();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> startDetection() async {
    try {
      await _faceDetectorService.startDetection();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> stopDetection() async {
    try {
      await _faceDetectorService.stopDetection();
    } catch (e) {
      rethrow;
    }
  }

  void dispose() {
    _faceDetectorService.dispose();
  }
}