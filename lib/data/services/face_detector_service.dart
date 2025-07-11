import 'dart:async';
import 'dart:ui';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:camera/camera.dart';

class FaceDetectorService {
  final FaceDetector _faceDetector;
  CameraController? _cameraController;
  bool _isDetecting = false;
  bool _isInitialized = false;

  FaceDetectorService() : _faceDetector = FaceDetector(options: FaceDetectorOptions());

  Future<void> initializeCamera() async {
    if (_isInitialized) return;

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception('No cameras available');

      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.nv21,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      _isInitialized = true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> startDetection() async {
    if (_isDetecting) {
      return;
    }
    
    try {
    
      if (!_isInitialized) {
        await initializeCamera();
      }

      _isDetecting = true;

      await _cameraController!.startImageStream((CameraImage image) {
        if (!_isDetecting) return;
        
        _processCameraImage(image);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> stopDetection() async {
    if (!_isDetecting) {
      return;
    }

    _isDetecting = false;
    
    if (_cameraController != null) {
      await _cameraController!.stopImageStream();
    }
  }

  void _processCameraImage(CameraImage image) async {
    if (!_isDetecting) return;

    try {
      final inputImage = _convertCameraImageToInputImage(image);
      if (inputImage == null) {
        return;
      }

      await _faceDetector.processImage(inputImage);
    } catch (e) {
      rethrow;
    }
  }

  InputImage? _convertCameraImageToInputImage(CameraImage image) {
    if (_cameraController == null) {
      return null;
    }

    final camera = _cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    int rotationCompensation = (sensorOrientation + 90) % 360;
    rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    if (rotation == null) {
      return null;
    }

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) {
      return null;
    }

    if (image.planes.length != 1) {
      return null;
    }
    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  void dispose() {
    stopDetection();
    _cameraController?.dispose();
    _faceDetector.close();
  }
}