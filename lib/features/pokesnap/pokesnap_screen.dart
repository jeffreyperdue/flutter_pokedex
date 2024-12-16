// File: lib/features/pokesnap/pokesnap_screen.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class PokeSnapScreen extends StatefulWidget {
  @override
  _PokeSnapScreenState createState() => _PokeSnapScreenState();
}

class _PokeSnapScreenState extends State<PokeSnapScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _cameraController = CameraController(cameras![0], ResolutionPreset.high);
      await _cameraController?.initialize();
      setState(() {
        isCameraInitialized = true;
      });
    } else {
      print('No cameras available.');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void capturePhoto() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final image = await _cameraController!.takePicture();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageProcessingScreen(imagePath: image.path),
          ),
        );
      } catch (e) {
        print('Error capturing photo: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PokeSnap'),
      ),
      body: isCameraInitialized
          ? Stack(
              children: [
                CameraPreview(_cameraController!),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: capturePhoto,
                      child: Text('Capture'),
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class ImageProcessingScreen extends StatelessWidget {
  final String imagePath;

  const ImageProcessingScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    // Placeholder UI for image processing screen
    return Scaffold(
      appBar: AppBar(
        title: Text('Processing Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Processing image...'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
