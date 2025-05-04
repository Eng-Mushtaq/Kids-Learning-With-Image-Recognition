import os
import urllib.request
import zipfile
import shutil

def download_model():
    # Create models directory if it doesn't exist
    os.makedirs('assets/models', exist_ok=True)
    
    # URL for the TensorFlow Lite model
    model_url = "https://storage.googleapis.com/download.tensorflow.org/models/tflite/coco_ssd_mobilenet_v1_1.0_quant_2018_06_29.zip"
    zip_path = "model.zip"
    
    # Download the model
    print(f"Downloading model from {model_url}...")
    urllib.request.urlretrieve(model_url, zip_path)
    
    # Extract the model
    print("Extracting model...")
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall("temp_model")
    
    # Move the model files to the assets directory
    shutil.copy("temp_model/detect.tflite", "assets/models/object_labeler.tflite")
    shutil.copy("temp_model/labelmap.txt", "assets/models/labelmap.txt")
    
    # Clean up
    os.remove(zip_path)
    shutil.rmtree("temp_model")
    
    print("Model downloaded and extracted successfully!")

if __name__ == "__main__":
    download_model()
