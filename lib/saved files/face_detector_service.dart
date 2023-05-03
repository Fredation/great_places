// import 'package:airvend/features/account/statement_limit/presentation/widgets/camera.service.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// class FaceDetectorService {
//   final CameraService _cameraService = CameraService();

//   late FaceDetector _faceDetector;
//   FaceDetector get faceDetector => _faceDetector;

//   List<Face> _faces = [];
//   List<Face> get faces => _faces;
//   bool get faceDetected => _faces.isNotEmpty;

//   void initialize() {
//     _faceDetector = FaceDetector(
//       options: FaceDetectorOptions(
//         performanceMode: FaceDetectorMode.accurate,
//         enableClassification: true,
//       ),
//     );
//   }

//   Future<void> detectFacesFromImage(CameraImage image) async {
//     final WriteBuffer allBytes = WriteBuffer();
//     for (Plane plane in image.planes) {
//       allBytes.putUint8List(plane.bytes);
//     }
//     final bytes = allBytes.done().buffer.asUint8List();

//     final Size imageSize =
//         Size(image.width.toDouble(), image.height.toDouble());

//     InputImageRotation imageRotation =
//         _cameraService.cameraRotation ?? InputImageRotation.rotation0deg;

//     final inputImageData = InputImageData(
//       size: imageSize,
//       imageRotation: imageRotation,
//       inputImageFormat: InputImageFormat.yuv420,
//       planeData: image.planes.map(
//         (Plane plane) {
//           return InputImagePlaneMetadata(
//             bytesPerRow: plane.bytesPerRow,
//             height: plane.height,
//             width: plane.width,
//           );
//         },
//       ).toList(),
//     );

//     InputImage _firebaseVisionImage = InputImage.fromBytes(
//       bytes: bytes,
//       inputImageData: inputImageData,
//     );

//     _faces = await _faceDetector.processImage(_firebaseVisionImage);
//   }

//   Future<void> detectFacesFromXFile(XFile image) async {
//     InputImage _firebaseVisionImage = InputImage.fromFilePath(image.path);
//     _faces = await _faceDetector.processImage(_firebaseVisionImage);
//   }

//   dispose() {
//     _faceDetector.close();
//   }
// }
