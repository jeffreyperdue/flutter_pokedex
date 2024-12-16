import 'dart:io';
import 'package:flutter/material.dart';

class ImageProcessingScreen extends StatelessWidget {
  final String imagePath;

  const ImageProcessingScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Processing Image'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(File(imagePath)), // Display the captured image
          SizedBox(height: 20),
          Text('Processing the image to identify Pokémon...'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Mock Pokémon identification result
              Navigator.pop(context);
            },
            child: Text('Simulate Pokémon Identification'),
          ),
        ],
      ),
    );
  }
}
