import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:kids_learning/RealTimeDetection/tflite_detector.dart';
import 'package:path_provider/path_provider.dart';

class TFLiteDetectionScreen extends StatefulWidget {
  @override
  _TFLiteDetectionScreenState createState() => _TFLiteDetectionScreenState();
}

class _TFLiteDetectionScreenState extends State<TFLiteDetectionScreen>
    with SingleTickerProviderStateMixin {
  // Camera controller
  CameraController? _cameraController;
  List<CameraDescription> cameras = [];
  bool _isCameraInitialized = false;

  // TFLite detector
  TFLiteDetector? _detector;
  Map<String, Map<String, dynamic>> _detectedObjects = {};

  // UI state
  bool _isPaused = false;
  bool _isProcessingFrame = false;
  String _selectedCategory = CategoryMapper.ANIMAL; // Default category
  TabController? _tabController;

  // Model selection state
  bool _animalOptimizationEnabled =
      true; // Default to animal optimization for better detection
  bool _isYOLOModelAvailable = false; // Track if YOLOv5 model is available
  bool _isChangingMode = false;

  // Frame processing
  Timer? _processingTimer;
  int _processingIntervalMs = 1000; // Default to 1 second between captures

  // Performance tracking
  int _framesProcessed = 0;
  double _currentFps = 0;
  String _detectionStatus = "Detecting...";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        switch (_tabController!.index) {
          case 0:
            _selectedCategory = CategoryMapper.ANIMAL;
            break;
          case 1:
            _selectedCategory = CategoryMapper.VEGETABLE;
            break;
          case 2:
            _selectedCategory = CategoryMapper.FRUIT;
            break;
        }
      });
    });

    // Initialize camera and detector
    _initializeCamera();
    _initializeDetector();

    // Start performance tracking
    _startPerformanceTracking();
  }

  void _startPerformanceTracking() {
    // Update FPS every second
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentFps = _framesProcessed.toDouble();
          _framesProcessed = 0;
        });
      }
    });
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        print('No cameras available');
        return;
      }

      // Use the first back camera
      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      // Initialize camera controller
      _cameraController = CameraController(
        camera,
        ResolutionPreset.high, // Higher resolution for better detection
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _cameraController!.initialize();

      if (!mounted) return;

      // Wait a moment for camera to stabilize
      await Future.delayed(Duration(milliseconds: 300));

      setState(() {
        _isCameraInitialized = true;
      });

      // Start periodic image capture
      _startPeriodicCapture();

      print('Camera initialized successfully');
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _initializeDetector() async {
    _detector = TFLiteDetector();
    print('TFLite detector initialized');

    // Check if YOLOv5 model is available
    _checkYOLOModelAvailability();
  }

  void _startPeriodicCapture() {
    _processingTimer?.cancel();
    _processingTimer =
        Timer.periodic(Duration(milliseconds: _processingIntervalMs), (timer) {
      if (!_isPaused && !_isProcessingFrame && _isCameraInitialized) {
        _captureAndDetect();
      }
    });
  }

  Future<void> _captureAndDetect() async {
    if (_isProcessingFrame || _isPaused || _cameraController == null) return;

    _isProcessingFrame = true;
    setState(() {
      _detectionStatus = "Processing...";
    });

    try {
      // Take picture
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Two approaches:
      // 1. Take picture and save to file (better memory management but slower)
      // 2. Process from camera image directly (faster but higher memory usage)

      // Approach 1: Take picture approach
      final XFile picture = await _cameraController!.takePicture();
      await picture.saveTo(filePath);
      final imageFile = File(filePath);

      // Process the image
      final detections = await _detector?.detectObjectsFromFile(imageFile);

      // Clean up temp file
      try {
        await imageFile.delete();
      } catch (e) {
        print('Error deleting temp file: $e');
      }

      // Update UI with results
      if (detections != null && mounted) {
        setState(() {
          _detectedObjects = detections;
          _framesProcessed++;
          _detectionStatus =
              detections.isEmpty ? "No objects detected" : "Detection complete";
        });
      }
    } catch (e) {
      print('Error processing image: $e');
      setState(() {
        _detectionStatus = "Detection error";
      });
    } finally {
      _isProcessingFrame = false;
    }
  }

  Future<void> _checkYOLOModelAvailability() async {
    if (_detector != null) {
      final isAvailable = await _detector!.checkYOLOModelAvailable();
      setState(() {
        _isYOLOModelAvailable = isAvailable;
      });
      print('YOLOv5 model available: $_isYOLOModelAvailable');
    }
  }

  // Set processing interval
  void _setProcessingInterval(int intervalMs) {
    _processingIntervalMs = intervalMs;
    if (_detector != null) {
      _detector!.setProcessingInterval(intervalMs);
    }
    // Restart the timer with new interval
    _startPeriodicCapture();
  }

  // New method to toggle between models
  Future<void> _toggleModel() async {
    if (_detector == null || _isChangingMode) return;

    // Check if YOLOv5 model is available
    final isAvailable = await _detector!.checkYOLOModelAvailable();

    if (!isAvailable) {
      // Show dialog about downloading the model
      _showModelDownloadDialog();
      return;
    }

    setState(() {
      _isChangingMode = true;
      _isPaused = true;
      _detectionStatus = "Switching model...";
    });

    // Pause processing
    _processingTimer?.cancel();

    // Current model state
    final currentlyUsingYOLO = _detector!.isUsingYOLOModel();

    // Switch models
    final success = await _detector!.setUseYOLOModel(!currentlyUsingYOLO);

    // Clear current detections
    setState(() {
      _detectedObjects = {};
    });

    // Resume processing
    _startPeriodicCapture();

    setState(() {
      _isPaused = false;
      _isChangingMode = false;
      _detectionStatus = "Ready";
    });

    // Show confirmation to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? 'Switched to ${_detector!.getCurrentModelName()} model'
            : 'Failed to switch models, using ${_detector!.getCurrentModelName()}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Show dialog about downloading the model
  void _showModelDownloadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('YOLOv5 Model Not Found'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'The YOLOv5 model file is not available in your assets folder.'),
            SizedBox(height: 10),
            Text('To download the model, run the following command:'),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Text('python download_yolov5.py',
                  style: TextStyle(fontFamily: 'monospace')),
            ),
            SizedBox(height: 10),
            Text('Then restart the app to use the YOLOv5 model.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      _detectionStatus = _isPaused ? "Paused" : "Resuming...";
    });
  }

  void _toggleOptimizationMode() async {
    if (_isChangingMode) return;

    setState(() {
      _isChangingMode = true;
      _isPaused = true;
      _detectionStatus = "Updating settings...";
    });

    // Pause processing
    _processingTimer?.cancel();

    // Toggle the optimization mode
    _animalOptimizationEnabled = !_animalOptimizationEnabled;

    // Update the detector's optimization setting
    _detector?.setAnimalOptimization(_animalOptimizationEnabled);

    // Clear current detections
    setState(() {
      _detectedObjects = {};
    });

    // Resume processing
    _startPeriodicCapture();

    setState(() {
      _isPaused = false;
      _isChangingMode = false;
      _detectionStatus = "Ready";
    });

    // Show confirmation to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_animalOptimizationEnabled
            ? 'Animal detection optimization enabled'
            : 'Using standard detection mode'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Change detection speed
  void _changeDetectionSpeed(String speed) {
    int interval;
    switch (speed) {
      case 'slow':
        interval = 2000; // 2 seconds - less memory usage
        break;
      case 'normal':
        interval = 1000; // 1 second - balanced
        break;
      case 'fast':
        interval = 500; // 0.5 seconds - higher memory usage
        break;
      default:
        interval = 1000;
    }

    _setProcessingInterval(interval);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Detection speed set to ${speed} (${interval}ms)'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    _processingTimer?.cancel();
    _tabController?.dispose();
    _cameraController?.dispose();
    _detector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Count detected objects by category
    int animalCount = 0;
    int vegetableCount = 0;
    int fruitCount = 0;

    _detectedObjects.forEach((_, objectData) {
      final category = objectData['category'] as String;
      if (category == CategoryMapper.ANIMAL) {
        animalCount++;
      } else if (category == CategoryMapper.VEGETABLE) {
        vegetableCount++;
      } else if (category == CategoryMapper.FRUIT) {
        fruitCount++;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Detection'),
        elevation: 0,
        actions: [
          // Add detection speed dropdown
          PopupMenuButton<String>(
            icon: Icon(Icons.speed),
            tooltip: 'Detection Speed',
            onSelected: _changeDetectionSpeed,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'slow',
                child: Text('Slow (Memory Saving)'),
              ),
              PopupMenuItem(
                value: 'normal',
                child: Text('Normal (Balanced)'),
              ),
              PopupMenuItem(
                value: 'fast',
                child: Text('Fast (Performance)'),
              ),
            ],
          ),
          // Add model toggle button in app bar
          IconButton(
            icon: Icon(
                _animalOptimizationEnabled ? Icons.pets : Icons.photo_camera),
            tooltip: _animalOptimizationEnabled
                ? 'Animal detection optimized'
                : 'Standard detection mode',
            onPressed: _toggleOptimizationMode,
          ),
          // Add YOLOv5 model switch button if available
          IconButton(
            icon: Icon(Icons.model_training),
            tooltip: 'Switch detection model',
            onPressed: _toggleModel,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              icon: Icon(Icons.pets),
              text: 'Animals ($animalCount)',
            ),
            Tab(
              icon: Icon(Icons.eco),
              text: 'Vegetables ($vegetableCount)',
            ),
            Tab(
              icon: Icon(Icons.apple),
              text: 'Fruits ($fruitCount)',
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
                // Camera preview
                if (_isCameraInitialized) CameraPreview(_cameraController!),

                // Loading indicator if camera not initialized or changing model
                if (!_isCameraInitialized || _isChangingMode)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          _isChangingMode
                              ? 'Switching detection mode...'
                              : 'Initializing camera...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                // YOLOv5 banner - updated to show status
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isYOLOModelAvailable
                          ? Colors.green.withOpacity(0.8)
                          : Colors.amber.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _isYOLOModelAvailable
                          ? (_detector != null && _detector!.isUsingYOLOModel()
                              ? 'Using YOLOv5 model for improved detection'
                              : 'YOLOv5 model available - tap model button to use it')
                          : 'YOLOv5 model can be downloaded - see instructions',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'arlrdbd',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                // Overlay for detected objects
                if (_detectedObjects.isNotEmpty)
                  CustomPaint(
                    painter: ObjectDetectionPainter(
                      _detectedObjects,
                      _selectedCategory,
                    ),
                    size: Size.infinite,
                  ),

                // Status overlay
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.black54,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _isPaused ? 'Paused' : _detectionStatus,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'arlrdbd',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'FPS: ${_currentFps.toStringAsFixed(1)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'arlrdbd',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          _detector != null
                              ? 'Using ${_detector!.getCurrentModelName()} - ' +
                                  (_animalOptimizationEnabled
                                      ? 'Animal optimization ON'
                                      : 'Standard detection mode')
                              : 'Initializing detector...',
                          style: TextStyle(
                            color: _animalOptimizationEnabled
                                ? Colors.amber
                                : Colors.white,
                            fontFamily: 'arlrdbd',
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // Actions
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Add model toggle button
                      FloatingActionButton.small(
                        heroTag: 'toggleModel',
                        onPressed: _toggleModel,
                        backgroundColor:
                            _detector != null && _detector!.isUsingYOLOModel()
                                ? Colors.green
                                : Colors.deepOrange,
                        child: Icon(Icons.model_training),
                      ),
                      SizedBox(height: 10),
                      // Add animal optimization toggle button
                      FloatingActionButton.small(
                        heroTag: 'toggleMode',
                        onPressed: _toggleOptimizationMode,
                        backgroundColor: _animalOptimizationEnabled
                            ? Colors.amber
                            : Colors.blue,
                        child: Icon(
                          _animalOptimizationEnabled
                              ? Icons.pets
                              : Icons.photo_camera,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Pause/resume button
                      FloatingActionButton(
                        heroTag: 'togglePause',
                        onPressed: _togglePause,
                        backgroundColor:
                            _isPaused ? Colors.green : Colors.deepPurple,
                        child: Icon(
                          _isPaused ? Icons.play_arrow : Icons.pause,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // List of detected objects for selected category
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Detected Objects',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'arlrdbd',
                            color: Colors.deepPurple,
                          ),
                        ),
                        Text(
                          _getCategoryTitle(),
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'arlrdbd',
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _buildDetectedObjectsList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectedObjectsList() {
    // Filter objects based on selected category
    final filteredObjects = _detectedObjects.entries
        .where((entry) => entry.value['category'] == _selectedCategory)
        .toList();

    // Sort by confidence (highest first)
    filteredObjects.sort((a, b) => (b.value['confidence'] as double)
        .compareTo(a.value['confidence'] as double));

    if (filteredObjects.isEmpty) {
      return Center(
        child: Text(
          'No ${_selectedCategory}s detected',
          style: TextStyle(
            color: Colors.grey[600],
            fontFamily: 'arlrdbd',
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredObjects.length,
      itemBuilder: (context, index) {
        final entry = filteredObjects[index];
        final objectName = entry.key;
        final objectData = entry.value;
        final confidence = objectData['confidence'] as double;
        final description = objectData['description'] as String;

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: _getCategoryIcon(objectData['category'] as String),
            title: Text(
              objectName,
              style: TextStyle(
                fontFamily: 'arlrdbd',
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: 'arlrdbd'),
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getConfidenceColor(confidence),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${(confidence * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'arlrdbd',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getCategoryTitle() {
    switch (_selectedCategory) {
      case CategoryMapper.ANIMAL:
        return 'Animals';
      case CategoryMapper.VEGETABLE:
        return 'Vegetables';
      case CategoryMapper.FRUIT:
        return 'Fruits';
      default:
        return 'All';
    }
  }

  Widget _getCategoryIcon(String category) {
    switch (category) {
      case CategoryMapper.ANIMAL:
        return CircleAvatar(
          backgroundColor: Colors.purple[100],
          child: Icon(Icons.pets, color: Colors.deepPurple),
        );
      case CategoryMapper.VEGETABLE:
        return CircleAvatar(
          backgroundColor: Colors.green[100],
          child: Icon(Icons.eco, color: Colors.green),
        );
      case CategoryMapper.FRUIT:
        return CircleAvatar(
          backgroundColor: Colors.orange[100],
          child: Icon(Icons.apple, color: Colors.orange),
        );
      default:
        return CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Icon(Icons.help_outline, color: Colors.grey),
        );
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) {
      return Colors.green;
    } else if (confidence >= 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

class ObjectDetectionPainter extends CustomPainter {
  final Map<String, Map<String, dynamic>> detectedObjects;
  final String selectedCategory;

  ObjectDetectionPainter(this.detectedObjects, this.selectedCategory);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint boxPaint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final Paint backgroundPaint = Paint()
      ..color = Colors.deepPurple.withOpacity(0.7);

    final TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    detectedObjects.forEach((label, objectData) {
      final category = objectData['category'] as String;

      // Only display objects matching the selected category
      if (category == selectedCategory) {
        final confidence = objectData['confidence'] as double;
        final rect = objectData['boundingBox'] as Rect;

        // Scale the bounding box to match the screen size
        final scaledRect = Rect.fromLTRB(
          rect.left * size.width,
          rect.top * size.height,
          rect.right * size.width,
          rect.bottom * size.height,
        );

        // Draw bounding box
        canvas.drawRect(scaledRect, boxPaint);

        // Prepare label text
        final textSpan = TextSpan(
          text: '$label: ${(confidence * 100).toStringAsFixed(0)}%',
          style: textStyle,
        );

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();

        // Draw background for text
        final textBackground = Rect.fromLTWH(
          scaledRect.left,
          scaledRect.top - textPainter.height - 4,
          textPainter.width + 8,
          textPainter.height + 4,
        );

        canvas.drawRect(textBackground, backgroundPaint);

        // Draw text
        textPainter.paint(
          canvas,
          Offset(scaledRect.left + 4, scaledRect.top - textPainter.height - 2),
        );
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
