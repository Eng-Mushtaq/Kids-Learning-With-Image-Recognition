import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'real_time_detector.dart';
import 'tflite_detector.dart';

class RealTimeDetectionScreen extends StatefulWidget {
  @override
  _RealTimeDetectionScreenState createState() =>
      _RealTimeDetectionScreenState();
}

class _RealTimeDetectionScreenState extends State<RealTimeDetectionScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription> cameras = [];
  bool _isCameraInitialized = false;
  RealTimeDetector? _detector;
  Map<String, Map<String, dynamic>> _detectedObjects = {};
  bool _isPaused = false;
  bool _isProcessingFrame = false;
  FlutterTts flutterTts = FlutterTts();
  String _selectedCategory = CategoryClassifier.ANIMAL; // Default category

  // Performance monitoring
  DateTime? _lastFrameProcessed;
  int _framesProcessed = 0;
  double _avgFps = 0;
  int _memoryWarnings = 0;
  Timer? _performanceTimer;

  // Resolution control for 8GB devices
  ResolutionPreset _currentResolution = ResolutionPreset.high;

  // Performance mode
  bool _highPerformanceMode = true; // Default to high performance for 8GB RAM

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) {
        setState(() {
          switch (_tabController!.index) {
            case 0:
              _selectedCategory = CategoryClassifier.ANIMAL;
              break;
            case 1:
              _selectedCategory = CategoryClassifier.VEGETABLE;
              break;
            case 2:
              _selectedCategory = CategoryClassifier.FRUIT;
              break;
          }
        });
      }
    });

    // Start performance monitoring
    _performanceTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      _updatePerformanceMetrics();
    });
  }

  Future<void> _initializeServices() async {
    _initTts();
    _detector = RealTimeDetector();
    await _requestCameraPermission();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Camera permission is required to use this feature'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Update performance metrics
  void _updatePerformanceMetrics() {
    if (!mounted) return;

    setState(() {
      // Calculate FPS if frames have been processed
      if (_framesProcessed > 0 && _lastFrameProcessed != null) {
        final now = DateTime.now();
        final elapsed = now.difference(_lastFrameProcessed!).inMilliseconds;
        if (elapsed > 0) {
          // Weighted average to smooth values
          final instantFps = (_framesProcessed * 1000) / elapsed;
          _avgFps =
              _avgFps == 0 ? instantFps : (_avgFps * 0.7 + instantFps * 0.3);
          _framesProcessed = 0;
          _lastFrameProcessed = now;
        }
      }

      // Check if FPS is low, suggesting possible memory pressure
      if (_avgFps < 10 && _highPerformanceMode) {
        _memoryWarnings++;
        if (_memoryWarnings > 3) {
          _adjustForMemoryUsage();
        }
      } else if (_avgFps > 15) {
        _memoryWarnings = 0;
      }
    });
  }

  // Adjust camera and processing settings based on memory usage
  void _adjustForMemoryUsage() {
    print('Adjusting settings for high memory usage');

    if (_currentResolution == ResolutionPreset.high) {
      _switchResolution(ResolutionPreset.medium);
    } else if (_highPerformanceMode) {
      _highPerformanceMode = false;

      // This will affect the TFLite detector processing
      // (assuming TFLiteDetector is used by RealTimeDetector)

      // Force garbage collection
      WidgetsBinding.instance.scheduleFrameCallback((_) {
        // Run a microtask to encourage garbage collection
        Future.microtask(() {});
      });
    }
  }

  // Switch camera resolution
  Future<void> _switchResolution(ResolutionPreset newResolution) async {
    if (_currentResolution == newResolution || !_isCameraInitialized) return;

    setState(() {
      _isPaused = true;
      _isCameraInitialized = false;
    });

    await _cameraController?.stopImageStream();
    await _cameraController?.dispose();

    _currentResolution = newResolution;

    // Reinitialize with new settings
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      backCamera,
      _currentResolution,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    try {
      await _cameraController?.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _isPaused = false;
        });

        await Future.delayed(Duration(milliseconds: 300));
        _cameraController?.startImageStream(_processCameraImage);
      }
    } catch (e) {
      print('Error reinitializing camera: $e');
    }
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        print('No cameras available');
        return;
      }

      // Use back camera for better results
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      print('Using camera: ${backCamera.name} (${backCamera.lensDirection})');

      _cameraController = CameraController(
        backCamera,
        _currentResolution, // Use the current resolution setting
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await _cameraController?.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });

        // Slight delay to ensure camera is stable before starting processing
        await Future.delayed(Duration(milliseconds: 500));
        _cameraController?.startImageStream(_processCameraImage);
        print('Camera stream started');
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _processCameraImage(CameraImage image) async {
    if (_isPaused || _isProcessingFrame) return;

    _isProcessingFrame = true;

    // Track frame processing for FPS calculation
    if (_lastFrameProcessed == null) {
      _lastFrameProcessed = DateTime.now();
      _framesProcessed = 0;
    }
    _framesProcessed++;

    try {
      // Create input image from camera image
      final camera = _cameraController!.description;

      // Get the camera orientation value
      int? rawRotation = camera.sensorOrientation;
      InputImageRotation rotation = InputImageRotation.rotation0deg;

      // Convert the raw rotation value to InputImageRotation enum
      if (rawRotation != null) {
        switch (rawRotation) {
          case 0:
            rotation = InputImageRotation.rotation0deg;
            break;
          case 90:
            rotation = InputImageRotation.rotation90deg;
            break;
          case 180:
            rotation = InputImageRotation.rotation180deg;
            break;
          case 270:
            rotation = InputImageRotation.rotation270deg;
            break;
        }
      }

      // Set the image format based on platform
      final InputImageFormat format = Platform.isAndroid
          ? InputImageFormat.nv21
          : InputImageFormat.bgra8888;

      // Process the image data
      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      // Create the input image using Google ML Kit API
      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      // Process the image with ML Kit
      final results = await _detector?.processImage(inputImage);

      if (results != null && mounted) {
        setState(() {
          // Reset previous results
          _detectedObjects = {};

          // Process new results
          for (final DetectedObject object in results) {
            for (final Label label in object.labels) {
              // Only consider high confidence detections for streaming mode
              if (label.confidence >= 0.6) {
                final category = CategoryClassifier.categorize(label.text);

                _detectedObjects[label.text] = {
                  'confidence': label.confidence,
                  'description': CategoryClassifier.getDescription(label.text),
                  'category': category,
                  'isSelectedCategory': category == _selectedCategory,
                  'boundingBox': object.boundingBox,
                };
              }
            }
          }
        });
      }
    } catch (e) {
      print('Error processing frame: $e');
    } finally {
      _isProcessingFrame = false;
    }
  }

  void _speakDescription(String text) {
    flutterTts.stop();
    flutterTts.speak(text);
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;

      if (_isPaused) {
        _cameraController?.stopImageStream();
      } else {
        _cameraController?.startImageStream(_processCameraImage);
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _isPaused = true;
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _detector?.close();
    flutterTts.stop();
    _performanceTimer?.cancel();
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
            'Real-Time Detection',
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

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple[500],
        elevation: 0,
        title: Text(
          'Real-Time Detection',
          style: TextStyle(color: Colors.white, fontFamily: "arlrdbd"),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.6),
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              icon: Icon(Icons.pets),
              text: 'Animals',
            ),
            Tab(
              icon: Icon(Icons.restaurant),
              text: 'Vegetables',
            ),
            Tab(
              icon: Icon(Icons.apple),
              text: 'Fruits',
            ),
          ],
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

                // Overlay for detected objects
                if (_detectedObjects.isNotEmpty)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ObjectOverlayPainter(
                          _detectedObjects, _selectedCategory),
                    ),
                  ),

                // Information overlay with performance metrics
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: Colors.black54,
                    child: Column(
                      children: [
                        Text(
                          _isPaused
                              ? "Detection paused - Processing image"
                              : "Point camera at objects to detect",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "arlrdbd",
                            fontSize: 14,
                          ),
                        ),
                        // Performance data
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              margin: EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                color: _getPerformanceColor(),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "FPS: ${_avgFps.toStringAsFixed(1)} | Mode: ${_highPerformanceMode ? 'High' : 'Battery Saver'}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontFamily: "arlrdbd",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Action buttons with quality controls
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Quality toggle button
                      FloatingActionButton.small(
                        heroTag: "qualityBtn",
                        backgroundColor: _getQualityButtonColor(),
                        onPressed: () {
                          if (_currentResolution == ResolutionPreset.high) {
                            _switchResolution(ResolutionPreset.medium);
                          } else {
                            _switchResolution(ResolutionPreset.high);
                          }
                        },
                        child: Icon(
                          _currentResolution == ResolutionPreset.high
                              ? Icons.high_quality
                              : Icons.sd,
                          color: Colors.white,
                        ),
                      ),

                      // Capture button
                      FloatingActionButton(
                        heroTag: "captureBtn",
                        backgroundColor: Colors.white,
                        onPressed: () async {
                          if (!_isPaused) {
                            setState(() {
                              _isPaused = true;
                              _detectedObjects = {};
                            });

                            _cameraController?.stopImageStream();
                            await Future.delayed(Duration(milliseconds: 500));

                            try {
                              final image =
                                  await _cameraController?.takePicture();
                              if (image != null) {
                                await _processImageFile(image.path);
                              }
                            } catch (e) {
                              print('Error taking picture: $e');
                            }
                          }
                        },
                        child: Icon(
                          Icons.camera,
                          color: Colors.deepPurple,
                          size: 36,
                        ),
                      ),

                      // Performance mode toggle
                      FloatingActionButton.small(
                        heroTag: "performanceBtn",
                        backgroundColor:
                            _highPerformanceMode ? Colors.green : Colors.orange,
                        onPressed: () {
                          setState(() {
                            _highPerformanceMode = !_highPerformanceMode;
                          });
                        },
                        child: Icon(
                          _highPerformanceMode
                              ? Icons.speed
                              : Icons.battery_saver,
                          color: Colors.white,
                        ),
                      ),

                      // Reset button (only shown when paused)
                      if (_isPaused)
                        FloatingActionButton(
                          heroTag: "resetBtn",
                          backgroundColor: Colors.red[400],
                          onPressed: () {
                            setState(() {
                              _isPaused = false;
                              _detectedObjects = {};
                            });
                            _cameraController
                                ?.startImageStream(_processCameraImage);
                          },
                          child: Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detected Objects:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "arlrdbd",
                        color: Colors.deepPurple,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'Filter: ${_getCategoryTitle()}',
                        style: TextStyle(
                          fontFamily: "arlrdbd",
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: _detectedObjects.isEmpty
                      ? Center(
                          child: Text(
                            'Point your camera at objects to detect them!',
                            style: TextStyle(
                              fontFamily: "arlrdbd",
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          itemCount: _detectedObjects.length,
                          itemBuilder: (context, index) {
                            final entry =
                                _detectedObjects.entries.elementAt(index);
                            final objectName = entry.key;
                            final objectData = entry.value;
                            final isSelectedCategory =
                                objectData['isSelectedCategory'] ?? false;

                            return ListTile(
                              title: Text(
                                objectName.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "arlrdbd",
                                  color: isSelectedCategory
                                      ? Colors.deepPurple
                                      : Colors.black54,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Category: ${objectData['category']}',
                                    style: TextStyle(
                                      fontFamily: "arlrdbd",
                                      fontStyle: FontStyle.italic,
                                      color: isSelectedCategory
                                          ? Colors.deepPurple[300]
                                          : Colors.black45,
                                    ),
                                  ),
                                  Text(
                                    'Confidence: ${(objectData['confidence'] * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(fontFamily: "arlrdbd"),
                                  ),
                                ],
                              ),
                              leading: Icon(
                                _getCategoryIcon(objectData['category']),
                                color: isSelectedCategory
                                    ? Colors.deepPurple
                                    : Colors.grey,
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.volume_up,
                                    color: Colors.deepPurple),
                                onPressed: () => _speakDescription(
                                  '${objectName}. ${objectData['description']}',
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case CategoryClassifier.ANIMAL:
        return Icons.pets;
      case CategoryClassifier.VEGETABLE:
        return Icons.restaurant;
      case CategoryClassifier.FRUIT:
        return Icons.apple;
      default:
        return Icons.category;
    }
  }

  String _getCategoryTitle() {
    switch (_selectedCategory) {
      case CategoryClassifier.ANIMAL:
        return 'Animals';
      case CategoryClassifier.VEGETABLE:
        return 'Vegetables';
      case CategoryClassifier.FRUIT:
        return 'Fruits';
      default:
        return 'Objects';
    }
  }

  // Process a captured image file
  Future<void> _processImageFile(String imagePath) async {
    print('Processing image file: $imagePath');

    try {
      // Create input image from file path
      final inputImage = InputImage.fromFilePath(imagePath);

      // Process the image with ML Kit
      final results = await _detector?.processImage(inputImage);

      if (mounted && results != null) {
        setState(() {
          _detectedObjects = {};

          for (final DetectedObject object in results) {
            for (final Label label in object.labels) {
              print(
                  'Detected object from file: ${label.text} (${label.confidence})');

              // We can use lower threshold for file processing as it's more accurate
              if (label.confidence >= 0.5) {
                final category = CategoryClassifier.categorize(label.text);

                _detectedObjects[label.text] = {
                  'confidence': label.confidence,
                  'description': CategoryClassifier.getDescription(label.text),
                  'category': category,
                  'isSelectedCategory': category == _selectedCategory,
                  'boundingBox': object.boundingBox,
                };
              }
            }
          }
        });
      }
    } catch (e) {
      print('Error processing image file: $e');
    }
  }

  // Gets color for performance indicator
  Color _getPerformanceColor() {
    if (_avgFps > 20) {
      return Colors.green;
    } else if (_avgFps > 10) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // Gets color for quality button
  Color _getQualityButtonColor() {
    return _currentResolution == ResolutionPreset.high
        ? Colors.blue
        : Colors.purple;
  }
}

class ObjectOverlayPainter extends CustomPainter {
  final Map<String, Map<String, dynamic>> detectedObjects;
  final String selectedCategory;

  ObjectOverlayPainter(this.detectedObjects, this.selectedCategory);

  @override
  void paint(Canvas canvas, Size size) {
    final boxPaint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final backgroundPaint = Paint()..color = Colors.deepPurple.withOpacity(0.7);

    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    detectedObjects.forEach((key, objectData) {
      // Only draw if the object is in the selected category or if we're showing all
      if (objectData['category'] == selectedCategory ||
          selectedCategory == 'all') {
        final confidence = objectData['confidence'] as double;
        final boundingBox = objectData['boundingBox'] as Rect?;

        // Draw the bounding box if available
        if (boundingBox != null) {
          // Scale bounding box to match the canvas size
          final scaledBox = Rect.fromLTRB(
            boundingBox.left * size.width,
            boundingBox.top * size.height,
            boundingBox.right * size.width,
            boundingBox.bottom * size.height,
          );

          // Draw the box
          canvas.drawRect(scaledBox, boxPaint);

          // Prepare text label
          final labelText = '$key: ${(confidence * 100).toStringAsFixed(0)}%';
          final textSpan = TextSpan(text: labelText, style: textStyle);
          final textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();

          // Draw background for the text
          final textBackgroundRect = Rect.fromLTWH(
            scaledBox.left,
            scaledBox.top - textPainter.height - 4,
            textPainter.width + 8,
            textPainter.height + 4,
          );
          canvas.drawRect(textBackgroundRect, backgroundPaint);

          // Draw the text
          textPainter.paint(
            canvas,
            Offset(scaledBox.left + 4, scaledBox.top - textPainter.height - 2),
          );
        }
      }
    });
  }

  @override
  bool shouldRepaint(ObjectOverlayPainter oldDelegate) {
    return oldDelegate.detectedObjects != detectedObjects ||
        oldDelegate.selectedCategory != selectedCategory;
  }
}
