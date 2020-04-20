import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';
import 'package:tran_dao/service/faceDetectorPainter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
class FaceMatch extends StatefulWidget {
  @override
  _FaceMatchState createState() => _FaceMatchState();
}

class _FaceMatchState extends State<FaceMatch> {
  List<Face> _faces = [];
  final _scanKey = GlobalKey<CameraMlVisionState>();
  CameraLensDirection cameraLensDirection = CameraLensDirection.front;
  FaceDetector detector =
      FirebaseVision.instance.faceDetector(FaceDetectorOptions(
    enableTracking: true,
    mode: FaceDetectorMode.accurate,
  ));
  Future<String> _requestTempDirectory() async{
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filePath = join(tempPath,'Test_capturedFace_${DateTime.now().microsecondsSinceEpoch}.jpg');
    return filePath;
  }
  // Future takePicture(String path,_cameraController) async {
  //   await _scanKey.currentState._stop(false);
  //   //FIXME hacky technique to avoid having black screen on some android devices
  //   await Future.delayed(Duration(milliseconds: 200));
  //   await _cameraController.takePicture(path);
  //   _cameraController._start();
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            child: 
              CameraMlVision<List<Face>>(
                key: _scanKey,
                cameraLensDirection: cameraLensDirection,
                detector: detector.processImage,
                overlayBuilder: (c) {
                  return CustomPaint(
                    painter: FaceDetectorPainter(
                        _scanKey.currentState.cameraValue.previewSize.flipped, _faces,
                        reflection: cameraLensDirection == CameraLensDirection.front),
                  );
                },
                onResult: (faces) {
                  if (faces == null || faces.isEmpty || !mounted) {
                    return;
                  }
                  _requestTempDirectory().then((path){
                    print(path);
                    try {
                      // _scanKey.currentState.takePicture(path);
                      // takePicture(path,_scanKey.currentState.cameraController);
                    } catch (e) {
                      // takePicture(path,_scanKey.currentState.cameraController);
                    }
                  });
                  setState(() {
                    _faces = []..addAll(faces);
                    print(faces[0].trackingId);
                  });
                },
                onDispose: () {
                  detector.close();
                },
              ),
          ),
        ]
      ),
    );
  }
}
