$modelUrl = "https://storage.googleapis.com/download.tensorflow.org/models/tflite/coco_ssd_mobilenet_v1_1.0_quant_2018_06_29.zip"
$outputZip = "model.zip"

# Download the model
Invoke-WebRequest -Uri $modelUrl -OutFile $outputZip

# Extract the zip file
Expand-Archive -Path $outputZip -DestinationPath "temp"

# Move the required files
Move-Item -Path "temp/detect.tflite" -Destination "assets/models/ssd_mobilenet.tflite"
Move-Item -Path "temp/labelmap.txt" -Destination "assets/models/ssd_mobilenet.txt"

# Clean up
Remove-Item -Path $outputZip
Remove-Item -Path "temp" -Recurse 