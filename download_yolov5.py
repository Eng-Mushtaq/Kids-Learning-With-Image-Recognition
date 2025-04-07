#!/usr/bin/env python3
"""
Download script for YOLOv5 TFLite model from Kaggle
This script downloads the YOLOv5 TFLite model and places it in the assets/models directory
"""

import os
import shutil
import sys

try:
    import kagglehub
except ImportError:
    print("Installing kagglehub package...")
    os.system("pip install kagglehub")
    import kagglehub

def main():
    print("Downloading YOLOv5 TFLite model from Kaggle...")
    
    # Download the model
    try:
        path = kagglehub.model_download("kaggle/yolo-v5/tfLite/tflite-tflite-model")
        print(f"Model downloaded to: {path}")
        
        # Get the asset directory path
        script_dir = os.path.dirname(os.path.abspath(__file__))
        asset_dir = os.path.join(script_dir, "assets", "models")
        
        # Check if the assets/models directory exists
        if not os.path.exists(asset_dir):
            os.makedirs(asset_dir)
            print(f"Created directory: {asset_dir}")
        
        # Find the .tflite file in the downloaded directory
        tflite_files = []
        for root, dirs, files in os.walk(path):
            for file in files:
                if file.endswith(".tflite"):
                    tflite_files.append(os.path.join(root, file))
        
        if not tflite_files:
            print("Error: No .tflite files found in the downloaded package")
            return False
        
        # Copy the first .tflite file to assets/models/yolov5s.tflite
        target_path = os.path.join(asset_dir, "yolov5s.tflite")
        shutil.copy(tflite_files[0], target_path)
        print(f"Model copied to: {target_path}")
        
        print("\nModel download completed successfully!")
        print("You can now use YOLOv5 in your Flutter app.")
        return True
        
    except Exception as e:
        print(f"Error downloading model: {e}")
        return False

if __name__ == "__main__":
    if main():
        sys.exit(0)
    else:
        sys.exit(1) 