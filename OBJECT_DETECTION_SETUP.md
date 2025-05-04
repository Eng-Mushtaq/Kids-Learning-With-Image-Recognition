# Object Detection Setup

This guide will help you set up the real-time object detection feature in the Kids Learning app.

## Prerequisites

- Flutter SDK installed
- Android Studio or VS Code with Flutter extensions
- A physical device for testing (emulators may not work well with camera features)

## Setup Steps

1. **Install Dependencies**

   The required dependencies have been added to the `pubspec.yaml` file. Run the following command to install them:

   ```bash
   flutter pub get
   ```

2. **Download the TensorFlow Lite Model**

   Run the provided Python script to download the pre-trained object detection model:

   ```bash
   python download_model.py
   ```

   This will download and extract the model files to the `assets/models` directory.

3. **Add Camera Icon**

   Add a camera icon image to the assets folder:
   
   - Create or download a camera icon image (PNG format)
   - Name it "camera.png"
   - Place it in the "assets/images/" directory

4. **Configure Android Permissions**

   Ensure that the camera permission is properly configured in your Android manifest file:

   Open `android/app/src/main/AndroidManifest.xml` and add the following permission:

   ```xml
   <uses-permission android:name="android.permission.CAMERA" />
   ```

5. **Configure iOS Permissions**

   For iOS, add camera usage description in the `ios/Runner/Info.plist` file:

   ```xml
   <key>NSCameraUsageDescription</key>
   <string>This app needs camera access to detect objects in real-time</string>
   ```

## Usage

1. Launch the app
2. On the home screen, tap the "Object Detection" tile
3. Grant camera permission when prompted
4. Point your camera at objects to detect them in real-time

## Features

- Real-time object detection using TensorFlow Lite
- Automatic learning progress tracking based on detected objects
- Support for both front and back cameras
- Option to toggle object labels on/off

## Troubleshooting

If you encounter issues:

1. **Camera not working**
   - Ensure camera permissions are granted
   - Restart the app
   - Check if the device has a compatible camera

2. **Model not loading**
   - Verify that the model files are in the correct location
   - Run the download script again

3. **Performance issues**
   - Lower the camera resolution in the code
   - Ensure the device has sufficient processing power

## Advanced Configuration

You can modify the object detection parameters in the `ObjectDetectorService` class:

- Change the confidence threshold
- Adjust the detection mode
- Use a different model

For more information, refer to the [Google ML Kit documentation](https://developers.google.com/ml-kit/vision/object-detection).
