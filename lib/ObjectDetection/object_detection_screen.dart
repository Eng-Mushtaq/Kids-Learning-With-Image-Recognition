import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

class ObjectDetectionScreen extends StatefulWidget {
  @override
  _ObjectDetectionScreenState createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
  CameraController? _cameraController;
  List<CameraDescription> cameras = [];
  bool _isCameraInitialized = false;
  FlutterTts flutterTts = FlutterTts();

  // List of common objects with educational descriptions
  final List<Map<String, String>> _educationalObjects = [
    {
      'name': 'Ball',
      'description':
          'A ball is a round object that we can throw, kick, or bounce. Many sports use balls!',
    },
    {
      'name': 'Apple',
      'description':
          'An apple is a sweet fruit that grows on trees. Apples are healthy and delicious!',
    },
    {
      'name': 'Cat',
      'description':
          'A cat is a small furry animal that people keep as a pet. Cats like to meow and purr!',
    },
    {
      'name': 'Dog',
      'description':
          'A dog is a friendly animal that can be a great pet. Dogs like to bark and wag their tails!',
    },
    {
      'name': 'Car',
      'description':
          'A car is a vehicle with four wheels that people use to travel from place to place.',
    },
    {
      'name': 'Book',
      'description':
          'A book is made of pages with words and pictures. We read books to learn and have fun!',
    },
    {
      'name': 'Tree',
      'description':
          'Trees are tall plants with leaves and branches. They give us clean air to breathe!',
    },
    {
      'name': 'Flower',
      'description':
          'Flowers are colorful parts of plants. They smell nice and can grow in gardens.',
    },
  ];

  int _currentObjectIndex = 0;

  @override
  void initState() {
    super.initState();
    _initTts();
    _requestCameraPermission();
  }

  void _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5); // Slower speech for kids
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _initializeCamera();
    } else {
      print('Camera permission denied');
    }
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        print('No cameras available');
        return;
      }

      _cameraController = CameraController(
        cameras[0],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController?.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _speakCurrentObject() {
    if (_educationalObjects.isNotEmpty) {
      final currentObject = _educationalObjects[_currentObjectIndex];
      flutterTts.speak(
          "Look for a ${currentObject['name']}! ${currentObject['description']}");
    }
  }

  void _nextObject() {
    setState(() {
      _currentObjectIndex =
          (_currentObjectIndex + 1) % _educationalObjects.length;
    });
    _speakCurrentObject();
  }

  void _previousObject() {
    setState(() {
      _currentObjectIndex =
          (_currentObjectIndex - 1 + _educationalObjects.length) %
              _educationalObjects.length;
    });
    _speakCurrentObject();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple[500],
          elevation: 0,
          title: Text(
            'Object Learning',
            style: TextStyle(color: Colors.white, fontFamily: "arlrdbd"),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
              SizedBox(height: 20),
              Text(
                "Initializing camera...",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontFamily: "arlrdbd",
                ),
              ),
            ],
          ),
        ),
      );
    }

    final currentObject = _educationalObjects[_currentObjectIndex];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple[500],
        elevation: 0,
        title: Text(
          'Find Objects',
          style: TextStyle(color: Colors.white, fontFamily: "arlrdbd"),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(_cameraController!),
                // Create a semi-transparent overlay with instructions
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Can you find a ${currentObject['name']}?",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "arlrdbd",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  currentObject['description'] ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "arlrdbd",
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _previousObject,
                      icon: Icon(Icons.arrow_back),
                      label: Text("Previous"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _speakCurrentObject,
                      icon: Icon(Icons.volume_up),
                      label: Text("Listen"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _nextObject,
                      icon: Icon(Icons.arrow_forward),
                      label: Text("Next"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
