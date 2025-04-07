$helperGradlePath = "$env:LOCALAPPDATA\Pub\Cache\hosted\pub.dev\tflite_flutter_helper-0.3.1\android\build.gradle"

# Create backup if not already created
if (-not (Test-Path "$helperGradlePath.bak")) {
    Copy-Item -Path $helperGradlePath -Destination "$helperGradlePath.bak" -Force
}

# Read content
$content = Get-Content -Path $helperGradlePath -Raw

# Update Kotlin version
$content = $content -replace "ext.kotlin_version = '1.3.50'", "ext.kotlin_version = '1.8.0'"

# Write modified content
Set-Content -Path $helperGradlePath -Value $content

Write-Host "Successfully updated tflite_flutter_helper Kotlin version to 1.8.0" 