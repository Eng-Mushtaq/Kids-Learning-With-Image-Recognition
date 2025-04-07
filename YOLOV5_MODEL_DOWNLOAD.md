# YOLOv5 Model Download Instructions

This guide will help you download and set up the YOLOv5 TFLite model for enhanced object detection in the Kids Learning App.

## Prerequisites

- Python 3.6 or higher
- Internet connection
- 300+ MB of free disk space for the model

## Download Steps

1. Make sure Python is installed on your system.

2. Run the provided download script from the project root:

```bash
python download_yolov5.py
```

3. The script will:
   - Install the `kagglehub` package if needed
   - Download the YOLOv5 TFLite model from Kaggle
   - Place the model in the `assets/models` directory as `yolov5s.tflite`

4. After the download completes, restart the Flutter app to use the YOLOv5 model.

## Using YOLOv5 in the App

1. Launch the app and navigate to the "Advanced Detection" screen.

2. Look for the green banner at the top indicating "YOLOv5 model available".

3. Tap the model toggle button (Icon: Model Training) in the app bar or floating action buttons.

4. The app will switch to using the YOLOv5 model, which provides improved object detection, especially for animals.

## Troubleshooting

If you encounter issues:

- Ensure Python is properly installed and accessible from your terminal
- Check that your internet connection is working
- Verify that you have sufficient disk space
- Make sure the download script completed successfully
- If needed, manually place the YOLOv5 TFLite model in the `assets/models` directory as `yolov5s.tflite`

## About YOLOv5

YOLOv5 (You Only Look Once) is a state-of-the-art object detection model that offers:

- Faster detection speed
- Better accuracy compared to SSD MobileNet
- Improved small object detection
- Better animal detection capability

The model used in this app is optimized for mobile devices and balanced for performance and accuracy.

## Alternative Download Method

If the download script doesn't work, you can manually download the model using:

```python
import kagglehub

# Download latest version
path = kagglehub.model_download("kaggle/yolo-v5/tfLite/tflite-tflite-model")

print("Path to model files:", path)
```

Then copy the `.tflite` file to your project's `assets/models` directory and rename it to `yolov5s.tflite`. 