import 'dart:async';
import 'dart:ui';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:camera/camera.dart';

class FaceDetectorService {
  final FaceDetector _faceDetector;
  CameraController? _cameraController;

  FaceDetectorService() : _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: false,
      enableContours: false,
      enableLandmarks: false,
      enableTracking: false,
      minFaceSize: 0.1
    )
  );

  final _faceStreamController = StreamController<List<Face>>.broadcast();
  Stream<List<Face>> get faceStream => _faceStreamController.stream;

  Future<void> initializeCamera() async {
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
    } catch (e) {
      rethrow;
    }
  }

  Future<void> startDetection() async {
    try {
      await _cameraController!.startImageStream((CameraImage image) {
        _processCameraImage(image);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> stopDetection() async {
    if (_cameraController != null) {
      await _cameraController!.stopImageStream();
    }
  }

  void _processCameraImage(CameraImage image) async {
    try {
      final inputImage = _convertCameraImageToInputImage(image);
      if (inputImage == null) {
        return;
      }

      final faces = await _faceDetector.processImage(inputImage);
      _faceStreamController.add(faces);
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