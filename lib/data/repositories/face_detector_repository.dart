import 'dart:async';
import 'package:collection/collection.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:voice_interaction/data/services/face_detector_service.dart';

class FaceDetectorRepository {
  final FaceDetectorService _faceDetectorService;

  final _faceStreamController = StreamController<bool>.broadcast();
  Stream<bool> get faceStream => _faceStreamController.stream;

  FaceDetectorRepository({required FaceDetectorService faceDetectorService})
      : _faceDetectorService = faceDetectorService {
    _handleFaceStream();
  }

  static const _yawThreshold = 15.0;
  static const _persistDuration = Duration(seconds: 3);
  static const _glitchTolerance = Duration(milliseconds: 200);

  bool _isPersisted = false;
  Timer? _presenceTimer;
  Timer? _absenceTimer;
  DateTime? _lastFaceTime;
  DateTime? _lastNoFaceTime;

  void _handleFaceStream() {
    _faceDetectorService.faceStream.listen((faces) {
      final now = DateTime.now();
      final facingFace = faces.firstWhereOrNull(
        (face) => _isFacingCamera(face)
      );

      final hasValidFace = facingFace != null;

      if (hasValidFace) {
        _lastFaceTime = now;
        _absenceTimer?.cancel();
        _absenceTimer = null;

        if (!_isPersisted) {
          if (_lastNoFaceTime != null &&
              now.difference(_lastNoFaceTime!) < _glitchTolerance) {
            return; // skip noise
          }

          _presenceTimer ??= Timer(_persistDuration, () {
            _isPersisted = true;
            _presenceTimer = null;
            _faceStreamController.add(true);
          });
        }
      } else {
        _lastNoFaceTime = now;
        _presenceTimer?.cancel();
        _presenceTimer = null;

        if (_isPersisted) {
          if (_lastFaceTime != null &&
              now.difference(_lastFaceTime!) < _glitchTolerance) {
            return; // skip noise
          }

          _absenceTimer ??= Timer(_persistDuration, () {
            _isPersisted = false;
            _absenceTimer = null;
            _faceStreamController.add(false);
          });
        }
      }
    });
  }

  bool _isFacingCamera(Face face) {
    final yaw = face.headEulerAngleY ?? 0.0;
    return yaw.abs() < _yawThreshold;
  }

  Future<void> initCamera() async => _faceDetectorService.initializeCamera();
  Future<void> startDetection() async => _faceDetectorService.startDetection();
  Future<void> stopDetection() async => _faceDetectorService.stopDetection();

  void dispose() {
    _faceStreamController.close();
    _presenceTimer?.cancel();
    _absenceTimer?.cancel();
    _faceDetectorService.dispose();
  }
}
