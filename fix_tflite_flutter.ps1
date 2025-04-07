$tfliteGradlePath = "$env:LOCALAPPDATA\Pub\Cache\hosted\pub.dev\tflite_flutter-0.9.1\android\build.gradle"

# Create backup
Copy-Item -Path $tfliteGradlePath -Destination "$tfliteGradlePath.bak" -Force

# Read content
$content = Get-Content -Path $tfliteGradlePath -Raw

# Add namespace if not present
if (-not ($content -match "namespace 'com.tfliteflutter.tflite_flutter_plugin'")) {
    $content = $content -replace "android \{", "android {`r`n    namespace 'com.tfliteflutter.tflite_flutter_plugin'"
}

# Write modified content
Set-Content -Path $tfliteGradlePath -Value $content

Write-Host "Successfully updated tflite_flutter build.gradle file with namespace" 