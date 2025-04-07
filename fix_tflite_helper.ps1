$helperGradlePath = "$env:LOCALAPPDATA\Pub\Cache\hosted\pub.dev\tflite_flutter_helper-0.3.1\android\build.gradle"

# Create backup
Copy-Item -Path $helperGradlePath -Destination "$helperGradlePath.bak" -Force

# Read content
$content = Get-Content -Path $helperGradlePath -Raw

# Add namespace if not present
if (-not ($content -match "namespace 'com.tfliteflutter.tflite_flutter_helper'")) {
    $content = $content -replace "android \{", "android {`r`n    namespace 'com.tfliteflutter.tflite_flutter_helper'"
}

# Write modified content
Set-Content -Path $helperGradlePath -Value $content

Write-Host "Successfully updated tflite_flutter_helper build.gradle file with namespace" 