# Kids Learning App

A Flutter application designed to help children learn about animals, vegetables, fruits, and more through interactive features, including real-time object detection.

## Features

- Object Detection: Detect objects in images using TensorFlow Lite
- Real-Time Detection: Use camera to detect objects in real-time
- Advanced Detection: Enhanced detection capabilities with optimized models
- Learning Categories: Animals, Vegetables, Fruits, and more
- Interactive UI: Child-friendly interface with visual and audio feedback

## Object Detection Models

### Current Implementation
- **SSD MobileNet**: Base model for object detection
- **Animal Optimization**: Enhanced detection for animals with boosted confidence scores

### Optional YOLOv5 Model
The app now supports the superior YOLOv5 model for improved detection accuracy:

1. **Download the YOLOv5 model**:
   ```
   python download_yolov5.py
   ```
   This script will download the model from Kaggle and place it in the correct location.

2. **Switch to YOLOv5 in the app**:
   - Navigate to "Advanced Detection"
   - Tap the model toggle button (icon: model_training)
   - A green banner indicates when YOLOv5 is available and in use

3. **Benefits of YOLOv5**:
   - Better accuracy for small objects
   - Improved animal detection
   - Faster processing on devices with 8GB RAM

See the [YOLOv5 Model Download Instructions](YOLOV5_MODEL_DOWNLOAD.md) for detailed steps.

## Hardware Requirements

The app is optimized for devices with:
- 8GB RAM or more
- Camera capability
- Android/iOS compatibility

## Usage

1. Select a learning mode from the home screen
2. For object detection, tap "Object Detection" or "Real-Time Detection"
3. Point your camera at objects to identify them
4. Use the "Advanced Detection" mode for better animal recognition
5. Toggle "Animal Optimization" for improved animal detection

## Performance Notes

- The app is optimized to balance detection accuracy and performance
- Memory management is implemented to prevent out-of-memory errors
- Frame processing is throttled to maintain a smooth experience

## Kaggle Integration

This app can now integrate with Kaggle's model repository to enhance its capabilities:

```python
import kagglehub

# Download latest version of YOLOv5
path = kagglehub.model_download("kaggle/yolo-v5/tfLite/tflite-tflite-model")
```

## Development

To contribute to this project:

1. Ensure you have Flutter setup on your system
2. Clone the repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to test the app

For model enhancements, the TFLite detector is designed to be easily extended with new models.
