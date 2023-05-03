// // ignore_for_file: unused_field, prefer_final_fields

// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// // import 'package:archive/archive_io.dart';

// import 'package:airvend/features/account/statement_limit/presentation/widgets/camera.service.dart';
// import 'package:airvend/features/account/statement_limit/presentation/widgets/face_detector_service.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// // import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// // import 'package:ionicons/ionicons.dart';
// import 'package:lottie/lottie.dart';
// // import 'package:pva_app/core/services/utils/ml_service.dart';
// import 'package:path_provider/path_provider.dart';

// // import '../../services/utils/ml_service.dart';

// class FaceDetectionProvider {
//   late CameraService? _cameraService;
//   late FaceDetectorService? _faceDetectorService;
//   // late MLService? _mlService;
//   Function? _action;

//   int _currentPage = 0;
//   int get currentPage => _currentPage;

//   List _predictedBVNImage = [];
//   dynamic _predictedBVNFace;

//   String? _cameraMessage = '';
//   String? get cameraMessage => _cameraMessage;

//   // bool _firstGesture = false;
//   // bool _secondGesture = false;

//   CameraImage? _cameraImage;

//   bool _isSmiling = false;

//   bool _isPictureTaken = false;
//   bool get isPictureTaken => _isPictureTaken;

//   bool _isInitializing = true;
//   bool get isInitializing => _isInitializing;

//   File? _bvnImage;
//   File? get bvnImage => _bvnImage;

//   bool _detectingFaces = false;

//   dynamic _imageSelfie;
//   dynamic get imageSelfie => _imageSelfie;

//   dynamic _videoSelfie;
//   dynamic get videoSelfie => _videoSelfie;

//   int _startCount = 59;
//   dynamic get startCount => _startCount;

//   bool _showResend = false;
//   dynamic get showResend => _showResend;

//   bool _disposed = false;
//   bool get disposed => _disposed;

//   @override
//   void dispose() {
//     _disposed = true;
//   }

//   initProvider(
//       CameraService cameraService,
//       FaceDetectorService faceDetectorService,
//       // MLService mlService,
//       Function action) {
//     _cameraService = cameraService;
//     _faceDetectorService = faceDetectorService;
//     // _mlService = mlService;
//     _action = action;
//   }

//   setCurrentPage(int page) {
//     _currentPage = page;
//     notifyListeners();
//   }

//   setCameraMessage(String message) {
//     _cameraMessage = message;
//     notifyListeners();
//   }

//   Future<bool> navPages() async {
//     if (_currentPage > 0) {
//       if (_currentPage == 2) {
//         if (_cameraService!.cameraController != null) {
//           // _cameraService!.cameraController!.stopImageStream();
//           _cameraMessage = "";
//           // _firstGesture = false;
//           // _secondGesture = false;
//           notifyListeners();
//         }
//         _currentPage = 0;
//         notifyListeners();
//         return false;
//       } else {
//         _currentPage = _currentPage - 1;
//         notifyListeners();
//         return false;
//       }
//     } else {
//       return true;
//     }
//   }

//   void startTimer() {
//     _showResend = false;
//     _startCount = 59;
//     notifyListeners();
//     const oneSec = Duration(seconds: 1);
//     Timer.periodic(
//       oneSec,
//       (Timer timer) {
//         if (!_disposed) {
//           if (_startCount == 0) {
//             timer.cancel();
//             _showResend = true;
//             _startCount = 59;
//             notifyListeners();
//           } else {
//             _startCount--;
//             notifyListeners();
//           }
//         }
//       },
//     );
//   }

//   // frameFaces() {
//   //   _cameraService!.cameraController!
//   //       .startImageStream((CameraImage image) async {
//   // assert(image != null, 'Image is null');
//   // if (_detectingFaces) return;
//   // _detectingFaces = true;
//   // await _faceDetectorService!.detectFacesFromImage(image);
//   // if (_faceDetectorService!.faceDetected) {
//   //   if (_faceDetectorService!.faces.length > 1) {
//   //     _cameraMessage = "multiple_faces";
//   //     notifyListeners();
//   //   } else {
//   //     double? _leftEye = Platform.isIOS
//   //         ? _faceDetectorService!.faces[0].leftEyeOpenProbability
//   //         : _faceDetectorService!.faces[0].rightEyeOpenProbability;
//   //     double? _rightEye = Platform.isIOS
//   //         ? _faceDetectorService!.faces[0].rightEyeOpenProbability
//   //         : _faceDetectorService!.faces[0].leftEyeOpenProbability;

//   //     if (!_firstGesture) {
//   //       _cameraMessage = "left_eye";
//   //       notifyListeners();
//   //       if (_rightEye! > 0.8 && _leftEye! < 0.2) {
//   //         _cameraMessage = "left_eye_complete";
//   //         _firstGesture = true;
//   //         notifyListeners();
//   //         await Future.delayed(const Duration(milliseconds: 1000));
//   //       }
//   //     } else {
//   //       if (!_secondGesture) {
//   //         _cameraMessage = "right_eye";
//   //         notifyListeners();

//   //         if (_rightEye! < 0.2 && _leftEye! > 0.8) {
//   //           _cameraMessage = "right_eye_complete";
//   //           _secondGesture = true;
//   //           notifyListeners();
//   //           await Future.delayed(const Duration(milliseconds: 1000));
//   //         }
//   //       } else {
//   //         _isSmiling =
//   //             (_faceDetectorService!.faces[0].smilingProbability ?? 0.44) >
//   //                 0.1;

//   //         if (_firstGesture && _secondGesture && _isSmiling) {
//   //           XFile? _file = await _cameraService!.takePicture();
//   //           _isPictureTaken = true;
//   //           _cameraMessage = "processing";
//   //           notifyListeners();
//   //           _cameraService!.cameraController!.startVideoRecording();
//   //           await Future.delayed(const Duration(milliseconds: 4000));
//   //           XFile? _videoFile = await _cameraService!.cameraController!
//   //               .stopVideoRecording();

//   //           _imageSelfie = await compressImage(File(_file!.path));
//   //           _videoSelfie = await compressVideo(File(_videoFile.path));
//   //           // List<dynamic> _predictedImage = _mlService!
//   //           //     .setCurrentPrediction(
//   //           //         image, _faceDetectorService!.faces[0]);

//   //           // bool _match =
//   //           //     _mlService!.matchFace(_predictedBVNImage, _predictedImage);
//   //           // bool _match = mlService!.matchFaceWithFace(
//   //           //     _predictedBVNFace, faceDetectorService!.faces[0]);
//   //           // if (_match) {
//   //           //   _cameraMessage = "face_match";
//   //           //   notifyListeners();
//   //           //   await Future.delayed(const Duration(milliseconds: 1500));
//   //           _action!();
//   //           _cameraMessage = "100";
//   //           notifyListeners();
//   //           // } else {
//   //           //   _cameraMessage = "mismatch";
//   //           //   notifyListeners();
//   //           // }
//   //         } else {
//   //           _cameraMessage = "no_smile";
//   //           notifyListeners();
//   //         }
//   //       }
//   //     }
//   //   }
//   // } else {
//   //   _cameraMessage = "no_face";
//   //   _firstGesture = false;
//   //   _secondGesture = false;
//   //   notifyListeners();
//   // }
//   // await Future.delayed(const Duration(milliseconds: 1000));
//   // _detectingFaces = false;
//   // });
//   // }

//   snapPicture() async {
//     XFile? _file = await _cameraService!.takePicture();
//     _isPictureTaken = true;
//     _cameraMessage = "processing";
//     notifyListeners();

//     if (_cameraImage != null) {
//       await _faceDetectorService!.detectFacesFromImage(_cameraImage!);
//     }

//     if (!_faceDetectorService!.faceDetected) {
//       goto.openDialog(const DialogueAlert(
//           content:
//               "No face detected on the image captured. Kindly position your face, smile and pressing the camera button whenever you are ready.",
//           title: "No Face Detected"));
//       _startStream();
//       _cameraMessage = "";
//       _isPictureTaken = false;
//       notifyListeners();
//     } else if (_faceDetectorService!.faces.length > 1) {
//       goto.openDialog(const DialogueAlert(
//           content:
//               "Multiple faces detected on the image captured. Kindly ensure you position only your face on the camera and pressing the camera button whenever you are ready.",
//           title: "Multiple Face Detected"));
//       _startStream();
//       _cameraMessage = "";
//       _isPictureTaken = false;
//       notifyListeners();
//     } else {
//       _cameraService!.cameraController!.startVideoRecording();
//       await Future.delayed(const Duration(milliseconds: 5000));
//       XFile? _videoFile =
//           await _cameraService!.cameraController!.stopVideoRecording();

//       _imageSelfie = await compressImage(File(_file!.path));
//       _videoSelfie = await compressVideo(File(_videoFile.path));

//       _action!();
//       _cameraMessage = "";
//       notifyListeners();
//     }
//   }

//   setBVNImage(String base64BVNImage) async {
//     final decodedBytes = base64Decode(base64BVNImage);
//     final appDocDir = await getApplicationDocumentsDirectory();
//     final appDocPath = appDocDir.path;

//     String _id = uuidGenerate().toString();
//     final file = File(appDocPath + "/$_id.png");
//     await file.writeAsBytes(decodedBytes);

//     _bvnImage = file;
//     notifyListeners();
//   }

//   _startStream() {
//     _cameraService!.cameraController!
//         .startImageStream((CameraImage image) async {
//       _cameraImage = image;
//     });
//   }

//   startCamera() {
//     _startStream();
//     goto.openDialog(_infoDialogue());
//   }

//   Future restart(CameraService cameraService) async {
//     _isPictureTaken = false;
//     // _firstGesture = false;
//     // _secondGesture = false;
//     _isInitializing = true;
//     notifyListeners();
//     await cameraService.initialize();
//     _isInitializing = false;
//     _cameraMessage = "";
//     notifyListeners();
//     startCamera();
//   }

//   void initCamera() async {
//     _isInitializing = true;
//     notifyListeners();
//     await _cameraService!.initialize();
//     _isInitializing = false;
//     notifyListeners();
//     startCamera();
//   }

//   _infoDialogue() {
//     return ContentDialogue(
//       action: () {},
//       title: "Face Capture",
//       content: SizedBox(
//         height: 300,
//         child: Column(children: [
//           Lottie.asset(
//             "assets/data/110250-face-id.json",
//             height: 150,
//           ),
//           const SizedBox(height: 0),
//           const Padding(
//               padding: EdgeInsets.only(right: 20, left: 20),
//               child: MainText(
//                 text:
//                     "For identification purposes, we need you to capture your face by pressing the camera button whenever you are ready.",
//                 style: TextStyle(fontSize: 11),
//               )),
//           Padding(
//               padding: const EdgeInsets.only(
//                   top: 20, bottom: 20, left: 20, right: 30),
//               child: Row(
//                 children: const [
//                   Icon(
//                     Icons.people,
//                     color: errorRed,
//                     size: 20,
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                       child: SubText(text: "Multiple faces are not allowed."))
//                 ],
//               ))
//         ]),
//       ),
//       confirm: false,
//     );
//   }
// }
