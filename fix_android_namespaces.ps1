$pluginNames = @(
    "camera|camera", 
    "camera_android|camera_android", 
    "tflite_flutter|tflite_flutter_plugin",
    "google_mlkit_barcode_scanning|google_mlkit_barcode_scanning",
    "google_mlkit_commons|google_mlkit_commons",
    "google_mlkit_digital_ink_recognition|google_mlkit_digital_ink_recognition",
    "google_mlkit_entity_extraction|google_mlkit_entity_extraction",
    "google_mlkit_face_detection|google_mlkit_face_detection",
    "google_mlkit_face_mesh_detection|google_mlkit_face_mesh_detection",
    "google_mlkit_image_labeling|google_mlkit_image_labeling",
    "google_mlkit_language_id|google_mlkit_language_id",
    "google_mlkit_object_detection|google_mlkit_object_detection",
    "google_mlkit_pose_detection|google_mlkit_pose_detection",
    "google_mlkit_selfie_segmentation|google_mlkit_selfie_segmentation",
    "google_mlkit_smart_reply|google_mlkit_smart_reply",
    "google_mlkit_text_recognition|google_mlkit_text_recognition",
    "google_mlkit_translation|google_mlkit_translation",
    "image_picker_android|image_picker_android",
    "path_provider_android|path_provider_android",
    "permission_handler_android|permission_handler_android",
    "url_launcher_android|url_launcher_android",
    "webview_flutter_android|webview_flutter_android",
    "flutter_plugin_android_lifecycle|flutter_plugin_android_lifecycle"
)

# Get Flutter cache directory path
$cacheDir = "$env:LOCALAPPDATA\Pub\Cache\hosted\pub.dev"

foreach ($pluginInfo in $pluginNames) {
    $pluginParts = $pluginInfo.Split("|")
    $pluginName = $pluginParts[0]
    $packageName = $pluginParts[1]
    
    # Find the plugin directory
    $pluginDirs = Get-ChildItem -Path $cacheDir -Directory -Filter "$pluginName-*" -ErrorAction SilentlyContinue
    
    if ($pluginDirs.Count -gt 0) {
        # Use the most recent version if multiple are found
        $pluginDir = $pluginDirs | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1
        Write-Host "Found $pluginName at: $($pluginDir.FullName)"
        
        # Path to the build.gradle file
        $buildGradlePath = Join-Path -Path $pluginDir.FullName -ChildPath "android\build.gradle"
        
        # Check if the file exists
        if (Test-Path $buildGradlePath) {
            # Make a backup of the original file if not already made
            $backupPath = "$buildGradlePath.bak"
            if (-not (Test-Path $backupPath)) {
                Copy-Item -Path $buildGradlePath -Destination $backupPath -Force
                Write-Host "Created backup at $backupPath"
            }
            
            # Read content
            $content = Get-Content -Path $buildGradlePath -Raw
            
            # Add namespace if not present
            if (-not ($content -match "namespace ")) {
                $content = $content -replace "android \{", "android {`r`n    namespace 'com.$packageName'"
                
                # Write modified content
                Set-Content -Path $buildGradlePath -Value $content
                Write-Host "Added namespace to $pluginName build.gradle file"
            } else {
                Write-Host "Namespace already present in $pluginName build.gradle file"
            }
        } else {
            Write-Host "Could not find build.gradle at $buildGradlePath"
        }
    } else {
        Write-Host "Could not find $pluginName in pub cache"
    }
}

Write-Host "Namespace patching complete!" 