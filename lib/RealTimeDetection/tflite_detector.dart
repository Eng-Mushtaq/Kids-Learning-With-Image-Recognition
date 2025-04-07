import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart';

// Categories for classification - keep consistent with the CategoryClassifier
class CategoryMapper {
  static const String ANIMAL = 'animal';
  static const String VEGETABLE = 'vegetable';
  static const String FRUIT = 'fruit';
  static const String OTHER = 'other';

  // Maps COCO dataset labels to our categories
  static String mapToCategory(String label) {
    label = label.toLowerCase().trim();

    // Animals
    if ([
      'bird',
      'cat',
      'dog',
      'horse',
      'sheep',
      'cow',
      'elephant',
      'bear',
      'zebra',
      'giraffe',
      'teddy bear',
      // Additional animals from COCO/YOLOv5
      'fox',
      'wolf',
      'tiger',
      'lion',
      'deer',
      'rabbit',
      'mouse',
      'squirrel',
      'raccoon',
      'monkey',
    ].contains(label)) {
      return ANIMAL;
    }

    // Vegetables
    if (['broccoli', 'carrot', 'hot dog', 'potted plant'].contains(label)) {
      return VEGETABLE;
    }

    // Fruits
    if (['banana', 'apple', 'orange'].contains(label)) {
      return FRUIT;
    }

    // Food items that could be categorized
    if (['sandwich', 'pizza', 'donut', 'cake', 'bowl'].contains(label)) {
      return VEGETABLE; // Default food to vegetable category for now
    }

    return OTHER;
  }
}

class TFLiteDetector {
  Interpreter? _interpreter;
  List<String>? _labels;
  bool _modelLoaded = false;
  bool _isProcessing = false;

  // Model selection
  bool _useYOLOModel =
      false; // Default to false until model is manually enabled

  // Memory management variables
  int _memoryWarningCount = 0;
  bool _lowMemoryMode = false;
  DateTime? _lastProcessingTime;

  // Processing interval in milliseconds (instead of frame counting)
  int _processingInterval = 1000; // Process every 1 second by default

  // Animal optimization flag
  bool _animalOptimizationEnabled = true; // Default to animal optimization

  // Model details for SSD MobileNet
  static const String SSD_MODEL_FILE_NAME =
      "assets/models/ssd_mobilenet.tflite";
  static const String SSD_LABELS_FILE_NAME = "assets/models/ssd_mobilenet.txt";

  // Model details for YOLOv5 (needs to be added to assets)
  static const String YOLO_MODEL_FILE_NAME = "assets/models/yolov5s.tflite";
  static const String YOLO_LABELS_FILE_NAME = "assets/models/yolov5_labels.txt";

  // Model parameters
  static const int INPUT_SIZE = 300; // SSD MobileNet size
  static const int YOLO_INPUT_SIZE = 320; // YOLOv5 size
  static const double THRESHOLD = 0.5;
  static const int MAX_RESULTS = 10;

  TFLiteDetector() {
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      print("Loading TFLite model...");
      // Load model from assets
      final options = InterpreterOptions();

      // Use threads for better performance - optimized for 8GB RAM
      options.threads = 6;

      // Use GPU delegate if available
      if (Platform.isAndroid) {
        try {
          options.addDelegate(GpuDelegateV2());
          print("GPU Delegate added");
        } catch (e) {
          print("Error adding GPU Delegate: $e");
        }
      }

      // Determine which model to load
      final modelPath =
          _useYOLOModel ? YOLO_MODEL_FILE_NAME : SSD_MODEL_FILE_NAME;
      final labelsPath =
          _useYOLOModel ? YOLO_LABELS_FILE_NAME : SSD_LABELS_FILE_NAME;

      print("Attempting to load model: $modelPath");

      try {
        // Load the model
        _interpreter = await Interpreter.fromAsset(
          modelPath,
          options: options,
        );

        // Load labels
        final labelsData = await rootBundle.loadString(labelsPath);
        _labels = labelsData.split('\n');

        _modelLoaded = true;
        print("TFLite model and labels loaded successfully");
        print("Model input shape: ${_interpreter!.getInputTensor(0).shape}");
        print("Model output shape: ${_interpreter!.getOutputTensor(0).shape}");
      } catch (e) {
        print("Error loading model file ($modelPath): $e");

        // If YOLOv5 fails to load, fall back to SSD MobileNet
        if (_useYOLOModel) {
          print("Falling back to SSD MobileNet model");
          _useYOLOModel = false;
          return _loadModel(); // Recursive call to load the SSD model instead
        }
      }
    } catch (e) {
      print("Error in _loadModel: $e");
    }
  }

  // Switch between models
  Future<bool> setUseYOLOModel(bool useYOLO) async {
    if (_useYOLOModel != useYOLO) {
      // Store current state to restore if loading fails
      final previousState = _useYOLOModel;
      _useYOLOModel = useYOLO;

      // Close current interpreter
      _interpreter?.close();
      _modelLoaded = false;

      try {
        await _loadModel();

        // Check if model loaded successfully
        if (!_modelLoaded) {
          throw Exception("Failed to load model");
        }

        return true; // Successfully switched models
      } catch (e) {
        print("Error switching models: $e");

        // Restore previous state on failure
        _useYOLOModel = previousState;
        await _loadModel(); // Reload previous model
        return false; // Failed to switch models
      }
    }
    return true; // No change needed
  }

  // Check if YOLOv5 model file exists
  Future<bool> checkYOLOModelAvailable() async {
    try {
      await rootBundle.load(YOLO_MODEL_FILE_NAME);
      return true;
    } catch (e) {
      print("YOLOv5 model not available: $e");
      return false;
    }
  }

  // Get current model name
  String getCurrentModelName() {
    return _useYOLOModel ? "YOLOv5" : "SSD MobileNet";
  }

  // Is YOLOv5 model in use
  bool isUsingYOLOModel() {
    return _useYOLOModel;
  }

  // Set processing interval in milliseconds
  void setProcessingInterval(int intervalMs) {
    _processingInterval = intervalMs;
    print("Set processing interval to $_processingInterval ms");
  }

  // Get current processing interval
  int getProcessingInterval() {
    return _processingInterval;
  }

  // Set animal optimization mode
  void setAnimalOptimization(bool enabled) {
    _animalOptimizationEnabled = enabled;
  }

  // Adaptive memory management
  void _adaptProcessingRate() {
    if (_memoryWarningCount > 3) {
      // If we've had several memory warnings, reduce processing rate
      _processingInterval = 2000; // 2 seconds between processing
      _lowMemoryMode = true;
      print("Reduced processing rate due to memory pressure");
    } else if (_memoryWarningCount == 0 && _lowMemoryMode) {
      // If we haven't had warnings for a while, go back to normal
      _processingInterval = 1000; // 1 second between processing
      _lowMemoryMode = false;
      print("Restored normal processing rate");
    }
  }

  // Clear cached resources
  void _clearResources() {
    PlatformDispatcher.instance.scheduleFrame();

    // Force Dart VM garbage collection hint
    Future.delayed(const Duration(milliseconds: 100), () {
      // Multiple GC hints spaced out
      PlatformDispatcher.instance.scheduleFrame();
    });
  }

  // New method to process a File image instead of CameraImage
  Future<Map<String, Map<String, dynamic>>> detectObjectsFromFile(
      File imageFile) async {
    if (!_modelLoaded || _isProcessing) {
      return {};
    }

    _isProcessing = true;
    Map<String, Map<String, dynamic>> detectedObjects = {};

    try {
      // Read the image file and convert to input format
      final img.Image? inputImage =
          img.decodeImage(await imageFile.readAsBytes());
      if (inputImage == null) {
        print("Failed to decode image file");
        return {};
      }

      // Process the image based on selected model
      if (_useYOLOModel) {
        detectedObjects = await _processImageWithYOLO(inputImage);
      } else {
        detectedObjects = await _processImageWithSSD(inputImage);
      }
    } catch (e) {
      print("Error during TFLite detection from file: $e");

      // Check if it's a memory error
      if (e.toString().contains("OutOfMemory") ||
          e.toString().contains("memory")) {
        _memoryWarningCount++;
        _processingInterval += 500; // Increase interval on memory errors
        print(
            "Memory pressure detected, increasing processing interval to $_processingInterval ms");
      }
    } finally {
      // Clear resources after processing
      _clearResources();
      _isProcessing = false;
    }

    return detectedObjects;
  }

  // Legacy method - keep for backward compatibility
  Future<Map<String, Map<String, dynamic>>> detectObjects(
      CameraImage cameraImage) async {
    if (!_modelLoaded || _isProcessing) {
      return {};
    }

    // Check if minimum time between processing has elapsed
    final now = DateTime.now();
    if (_lastProcessingTime != null) {
      final elapsed = now.difference(_lastProcessingTime!);
      if (elapsed.inMilliseconds < _processingInterval) {
        // Not enough time has passed since last processing
        return {};
      }
    }
    _lastProcessingTime = now;

    // Adapt processing rate based on memory conditions
    _adaptProcessingRate();

    _isProcessing = true;
    Map<String, Map<String, dynamic>> detectedObjects = {};

    try {
      // Process the image based on selected model
      if (_useYOLOModel) {
        detectedObjects = await _processWithYOLO(cameraImage);
      } else {
        detectedObjects = await _processWithSSD(cameraImage);
      }
    } catch (e) {
      print("Error during TFLite detection: $e");

      // Check if it's a memory error
      if (e.toString().contains("OutOfMemory") ||
          e.toString().contains("memory")) {
        _memoryWarningCount++;
        _processingInterval += 500; // Increase interval on memory errors
        print(
            "Memory pressure detected, increasing processing interval to $_processingInterval ms");
      }
    } finally {
      // Clear resources after processing
      _clearResources();
      _isProcessing = false;
    }

    return detectedObjects;
  }

  // Process using SSD MobileNet model (convert camera image to file first)
  Future<Map<String, Map<String, dynamic>>> _processWithSSD(
      CameraImage cameraImage) async {
    try {
      // Convert CameraImage to Image
      final img.Image? convertedImage = await _convertCameraImage(cameraImage);
      if (convertedImage == null) {
        return {};
      }

      // Use the common processing method
      return _processImageWithSSD(convertedImage);
    } catch (e) {
      print("Error in _processWithSSD: $e");
      return {};
    }
  }

  // Process using YOLOv5 model (convert camera image to file first)
  Future<Map<String, Map<String, dynamic>>> _processWithYOLO(
      CameraImage cameraImage) async {
    try {
      // Convert CameraImage to Image
      final img.Image? convertedImage = await _convertCameraImage(cameraImage);
      if (convertedImage == null) {
        return {};
      }

      // Use the common processing method
      return _processImageWithYOLO(convertedImage);
    } catch (e) {
      print("Error in _processWithYOLO: $e");
      return {};
    }
  }

  // Convert CameraImage to Image
  Future<img.Image?> _convertCameraImage(CameraImage image) async {
    try {
      if (image.format.group == ImageFormatGroup.yuv420) {
        return _convertYUV420ToImage(image);
      } else if (image.format.group == ImageFormatGroup.bgra8888) {
        return _convertBGRA8888ToImage(image);
      } else {
        print("Unsupported image format: ${image.format.group}");
        return null;
      }
    } catch (e) {
      print("Error converting camera image: $e");
      return null;
    }
  }

  // Convert YUV420 format to Image
  img.Image _convertYUV420ToImage(CameraImage cameraImage) {
    final width = cameraImage.width;
    final height = cameraImage.height;

    // Create an image
    final image = img.Image(width, height);

    final yPlane = cameraImage.planes[0].bytes;
    final uPlane = cameraImage.planes[1].bytes;
    final vPlane = cameraImage.planes[2].bytes;

    final yRowStride = cameraImage.planes[0].bytesPerRow;
    final uvRowStride = cameraImage.planes[1].bytesPerRow;
    final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    // Convert entire image at once - simpler approach for memory management
    for (int h = 0; h < height; h++) {
      for (int w = 0; w < width; w++) {
        final yIndex = h * yRowStride + w;
        final y = yPlane[yIndex];

        final uvIndex = (h ~/ 2) * uvRowStride + (w ~/ 2) * uvPixelStride;
        final u = uPlane[uvIndex];
        final v = vPlane[uvIndex];

        // Convert YUV to RGB
        int r = (y + 1.402 * (v - 128)).round().clamp(0, 255);
        int g =
            (y - 0.344 * (u - 128) - 0.714 * (v - 128)).round().clamp(0, 255);
        int b = (y + 1.772 * (u - 128)).round().clamp(0, 255);

        // Set the RGB value for this pixel
        image.setPixelRgba(w, h, r, g, b, 255);
      }
    }

    return image;
  }

  // Convert BGRA8888 format to Image
  img.Image _convertBGRA8888ToImage(CameraImage cameraImage) {
    final width = cameraImage.width;
    final height = cameraImage.height;

    // Create a new image
    final image = img.Image(width, height);

    // Get bytes
    final bytes = cameraImage.planes[0].bytes;
    final bytesPerPixel = 4; // BGRA has 4 bytes per pixel

    // Convert entire image at once
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixelIndex = (y * width + x) * bytesPerPixel;

        // BGRA format
        final b = bytes[pixelIndex];
        final g = bytes[pixelIndex + 1];
        final r = bytes[pixelIndex + 2];
        final a = bytes[pixelIndex + 3];

        image.setPixelRgba(x, y, r, g, b, a);
      }
    }

    return image;
  }

  // New method to process an img.Image with SSD MobileNet
  Future<Map<String, Map<String, dynamic>>> _processImageWithSSD(
      img.Image inputImage) async {
    Map<String, Map<String, dynamic>> detectedObjects = {};

    // Resize to expected input size
    final resizedImage = img.copyResize(
      inputImage,
      width: INPUT_SIZE,
      height: INPUT_SIZE,
      interpolation: img.Interpolation.nearest,
    );

    // Convert image to input format
    final processedInput = _preprocessImage(resizedImage, INPUT_SIZE);
    if (processedInput == null) {
      return {};
    }

    // Prepare output tensors
    final outputLocations =
        List.filled(1, List.filled(10, List.filled(4, 0.0)));
    final outputClasses = List.filled(1, List.filled(10, 0.0));
    final outputScores = List.filled(1, List.filled(10, 0.0));
    final numDetections = List.filled(1, 0.0);

    // Create outputs map
    final outputs = {
      0: outputLocations,
      1: outputClasses,
      2: outputScores,
      3: numDetections,
    };

    // Run inference
    _interpreter!.runForMultipleInputs([processedInput], outputs);

    // Process results similar to _processWithSSD
    final numDetected = numDetections[0].toInt();
    print("Detected $numDetected objects");

    for (int i = 0; i < numDetected; i++) {
      if (outputScores[0][i] >= THRESHOLD) {
        final labelIndex = outputClasses[0][i].toInt();

        // Check index is within range
        if (labelIndex < 0 || labelIndex >= (_labels?.length ?? 0)) {
          continue;
        }

        final label = _labels![labelIndex];
        var score = outputScores[0][i];

        // Apply animal optimization if enabled
        if (_animalOptimizationEnabled) {
          final category = CategoryMapper.mapToCategory(label);
          // Boost confidence for animals to improve detection
          if (category == CategoryMapper.ANIMAL) {
            score = (score * 1.2)
                .clamp(0.0, 1.0); // Increase animal confidence by 20%
          }
        }

        // Get bounding box
        final locations = outputLocations[0][i];
        final rect = Rect.fromLTRB(
          locations[1], // Left
          locations[0], // Top
          locations[3], // Right
          locations[2], // Bottom
        );

        // Map to our categories
        final category = CategoryMapper.mapToCategory(label);

        print(
            "TFLite detected: $label (${score.toStringAsFixed(2)}) - Category: $category");

        // Store in our detections map
        detectedObjects[label] = {
          'confidence': score,
          'category': category,
          'boundingBox': rect,
          'description': _getDescriptionForObject(label),
        };
      }
    }

    return detectedObjects;
  }

  // New method to process an img.Image with YOLOv5
  Future<Map<String, Map<String, dynamic>>> _processImageWithYOLO(
      img.Image inputImage) async {
    Map<String, Map<String, dynamic>> detectedObjects = {};

    // Resize to expected input size
    final resizedImage = img.copyResize(
      inputImage,
      width: YOLO_INPUT_SIZE,
      height: YOLO_INPUT_SIZE,
      interpolation: img.Interpolation.nearest,
    );

    // Convert image to input format
    final processedInput = _preprocessImage(resizedImage, YOLO_INPUT_SIZE);
    if (processedInput == null) {
      return {};
    }

    // YOLOv5 typically outputs a tensor of shape [1, 25200, 85]
    final outputShape = _interpreter!.getOutputTensor(0).shape;
    final outputSize = outputShape[1];
    final numClasses =
        outputShape[2] - 5; // -5 for 4 box coordinates and 1 objectness score

    final outputBuffer = List.filled(1 * outputSize * (numClasses + 5), 0.0);
    final outputTensor = [outputBuffer];

    // Run inference
    _interpreter!.run(processedInput, outputTensor);

    // Rest of the processing identical to _processWithYOLO
    final outputs = _reshapeList(outputBuffer, [1, outputSize, numClasses + 5]);

    List<Map<String, dynamic>> detections = [];

    for (int i = 0; i < outputSize; i++) {
      final confidence = outputs[0][i][4]; // Objectness score

      if (confidence > THRESHOLD) {
        // Extract box coordinates
        double x = outputs[0][i][0]; // Center x
        double y = outputs[0][i][1]; // Center y
        double w = outputs[0][i][2]; // Width
        double h = outputs[0][i][3]; // Height

        // Convert to corner coordinates
        double xmin = (x - w / 2);
        double ymin = (y - h / 2);
        double xmax = (x + w / 2);
        double ymax = (y + h / 2);

        // Find class with highest score
        double maxScore = 0;
        int classId = 0;

        for (int c = 0; c < numClasses; c++) {
          final score = outputs[0][i][5 + c];
          if (score > maxScore) {
            maxScore = score;
            classId = c;
          }
        }

        final finalScore = confidence * maxScore;

        if (finalScore > THRESHOLD) {
          detections.add({
            'classId': classId,
            'score': finalScore,
            'rect': Rect.fromLTRB(xmin, ymin, xmax, ymax),
          });
        }
      }
    }

    // Map detections to our format
    for (final detection in detections) {
      final labelIndex = detection['classId'];

      // Check index is within range
      if (labelIndex < 0 || labelIndex >= (_labels?.length ?? 0)) {
        continue;
      }

      final label = _labels![labelIndex];
      final score = detection['score'];
      final rect = detection['rect'];

      // Map to our categories
      final category = CategoryMapper.mapToCategory(label);

      print(
          "YOLOv5 detected: $label (${score.toStringAsFixed(2)}) - Category: $category");

      // Store in our detections map
      detectedObjects[label] = {
        'confidence': score,
        'category': category,
        'boundingBox': rect,
        'description': _getDescriptionForObject(label),
      };
    }

    return detectedObjects;
  }

  // Process image for model input
  List? _preprocessImage(img.Image image, int targetSize) {
    try {
      // Create a uint8 buffer
      final Uint8List inputBuffer = Uint8List(1 * targetSize * targetSize * 3);
      int pixelIndex = 0;

      // Extract pixels
      for (int y = 0; y < targetSize; y++) {
        for (int x = 0; x < targetSize; x++) {
          final pixel = image.getPixel(x, y);

          // Use uint8 values directly (0-255 range)
          inputBuffer[pixelIndex++] = img.getRed(pixel);
          inputBuffer[pixelIndex++] = img.getGreen(pixel);
          inputBuffer[pixelIndex++] = img.getBlue(pixel);
        }
      }

      // Reshape input to model's expected format (1, targetSize, targetSize, 3)
      return _reshapeList(inputBuffer, [1, targetSize, targetSize, 3]);
    } catch (e) {
      print("Error preprocessing image: $e");
      return null;
    }
  }

  // Helper method to reshape a list
  List _reshapeList(dynamic list, List<int> shape) {
    if (shape.length == 4) {
      final result = List.generate(
        shape[0],
        (i) => List.generate(
          shape[1],
          (j) => List.generate(
            shape[2],
            (k) => List.generate(
              shape[3],
              (l) {
                final index = i * shape[1] * shape[2] * shape[3] +
                    j * shape[2] * shape[3] +
                    k * shape[3] +
                    l;
                return index < list.length ? list[index] : 0;
              },
            ),
          ),
        ),
      );
      return result;
    }
    return list;
  }

  String _getDescriptionForObject(String label) {
    // Provide descriptions for common detected objects
    switch (label.toLowerCase()) {
      case 'person':
        return 'A human being.';
      case 'bird':
        return 'Birds have wings and can fly in the sky.';
      case 'cat':
        return 'A cat is a small furry animal that people keep as a pet.';
      case 'dog':
        return 'A dog is a loyal animal that can be a great pet.';
      case 'horse':
        return 'Horses are large animals that people can ride.';
      case 'sheep':
        return 'Sheep have wool that we use to make clothes.';
      case 'cow':
        return 'Cows give us milk that we drink.';
      case 'elephant':
        return 'Elephants are the largest land animals with long trunks.';
      case 'bear':
        return 'Bears are large, strong animals that can be dangerous.';
      case 'zebra':
        return 'Zebras have black and white stripes and look like horses.';
      case 'giraffe':
        return 'Giraffes have very long necks to reach leaves on tall trees.';
      case 'banana':
        return 'Bananas are yellow fruits with a curved shape.';
      case 'apple':
        return 'Apples are crunchy fruits that come in red, green, or yellow colors.';
      case 'orange':
        return 'Oranges are round, orange-colored fruits with sweet juice inside.';
      case 'broccoli':
        return 'Broccoli is a green vegetable that looks like a small tree.';
      case 'carrot':
        return 'Carrots are orange vegetables that grow underground.';
      // Add more animals for the enhanced model
      case 'fox':
        return 'Foxes are small wild animals with bushy tails and pointy ears.';
      case 'wolf':
        return 'Wolves are wild animals that look like large dogs and live in packs.';
      case 'tiger':
        return 'Tigers are large wild cats with orange fur and black stripes.';
      case 'lion':
        return 'Lions are large wild cats with golden fur. Male lions have manes.';
      case 'deer':
        return 'Deer are forest animals with antlers that eat plants and can run fast.';
      default:
        final category = CategoryMapper.mapToCategory(label);
        if (category == CategoryMapper.ANIMAL) {
          return 'This is an animal.';
        } else if (category == CategoryMapper.VEGETABLE) {
          return 'This is a vegetable that is good for your health.';
        } else if (category == CategoryMapper.FRUIT) {
          return 'This is a fruit that is sweet and delicious.';
        } else {
          return 'This is an object called $label.';
        }
    }
  }

  void close() {
    _interpreter?.close();
    print("TFLite detector closed");
  }
}
