import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:camera/camera.dart';

class FaceDetectorService {
  final FaceDetector _faceDetector;
  CameraController? _cameraController;
  bool _isDetecting = false;
  bool _isInitialized = false;

  FaceDetectorService() : _faceDetector = FaceDetector(options: FaceDetectorOptions());

  /// Initialize camera
  Future<bool> initializeCamera() async {
    if (_isInitialized) return true;

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return false;

      // Use front camera only
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
      debugPrint('Camera initialized successfully');
      return true;
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      return false;
    }
  }

  /// Start face detection from camera feed
  Future<bool> startDetection() async {
    if (_isDetecting) {
      debugPrint('Detection already running');
      return true;
    }

    if (!_isInitialized) {
      final initialized = await initializeCamera();
      if (!initialized) {
        debugPrint('Failed to initialize camera');
        return false;
      }
    }

    _isDetecting = true;
    debugPrint('Starting face detection...');

    // Start image stream
    await _cameraController!.startImageStream((CameraImage image) {
      if (!_isDetecting) return;
      
      _processCameraImage(image);
    });

    return true;
  }

  /// Stop face detection
  Future<void> stopDetection() async {
    if (!_isDetecting) {
      debugPrint('Detection not running');
      return;
    }

    _isDetecting = false;
    debugPrint('Stopping face detection...');
    
    if (_cameraController != null) {
      await _cameraController!.stopImageStream();
    }
    
    debugPrint('Face detection stopped');
  }

  /// Process camera image for face detection
  void _processCameraImage(CameraImage image) async {
    if (!_isDetecting) return;

    try {
      final inputImage = _convertCameraImageToInputImage(image);
      if (inputImage == null) {
        return;
      }

      final faces = await _faceDetector.processImage(inputImage);
      
      if (_isDetecting) {
        debugPrint('Faces detected: ${faces.length}');
      }
    } catch (e) {
      debugPrint('Error processing camera image: $e');
    }
  }

  /// Convert CameraImage to InputImage (fixed for landscapeLeft)
  InputImage? _convertCameraImageToInputImage(CameraImage image) {
    if (_cameraController == null) {
      debugPrint("Null controller, skipping processing");
      return null;
    }

    final camera = _cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;

    // Fixed rotation for landscapeLeft
    InputImageRotation? rotation;
    int rotationCompensation = (sensorOrientation + 90) % 360;
    rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    if (rotation == null) {
      debugPrint("Null rotation, skipping processing");
      return null;
    }

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null || format != InputImageFormat.nv21) {
      debugPrint("Null format - ${format.toString()}, skipping processing");
      return null;
    }

    if (image.planes.length != 1) {
      debugPrint("Unexpected number of planes: ${image.planes.length}");
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

  /// Check if detection is running
  bool get isDetecting => _isDetecting;

  /// Dispose resources
  void dispose() {
    stopDetection();
    _cameraController?.dispose();
    _faceDetector.close();
    debugPrint('FaceDetectorService disposed');
  }
}