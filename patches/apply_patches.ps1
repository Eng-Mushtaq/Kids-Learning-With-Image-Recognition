Write-Host "Applying patches to tflite_flutter plugin..."

# Get Flutter cache directory path
$flutterRoot = (flutter --version | Select-String -Pattern "Flutter version" | ForEach-Object { $_.Line.Split(" ")[2] }).Trim()
$cacheDir = "$env:LOCALAPPDATA\Pub\Cache\hosted\pub.dartlang.org"

# Find tflite_flutter directory
$tfliteDirs = Get-ChildItem -Path $cacheDir -Directory -Filter "tflite_flutter-*"

if ($tfliteDirs.Count -eq 0) {
    Write-Host "Could not find tflite_flutter in pub cache. Trying in .pub-cache..."
    $cacheDir = "$env:USERPROFILE\.pub-cache\hosted\pub.dev"
    $tfliteDirs = Get-ChildItem -Path $cacheDir -Directory -Filter "tflite_flutter-*"
}

if ($tfliteDirs.Count -eq 0) {
    Write-Host "Error: Could not find tflite_flutter in pub cache directories"
    exit 1
}

# Use the most recent version if multiple are found
$tfliteDir = $tfliteDirs | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1
Write-Host "Found tflite_flutter at: $($tfliteDir.FullName)"

# Path to the build.gradle file
$buildGradlePath = Join-Path -Path $tfliteDir.FullName -ChildPath "android\build.gradle"

# Check if the file exists
if (-not (Test-Path $buildGradlePath)) {
    Write-Host "Error: Could not find build.gradle at $buildGradlePath"
    exit 1
}

# Make a backup of the original file
$backupPath = "$buildGradlePath.bak"
if (-not (Test-Path $backupPath)) {
    Copy-Item -Path $buildGradlePath -Destination $backupPath
    Write-Host "Created backup at $backupPath"
}

# Apply the patch
$patchContent = Get-Content -Path "patches\tflite_flutter\build.gradle.patch" -Raw
Set-Content -Path $buildGradlePath -Value $patchContent

Write-Host "Successfully applied patch to tflite_flutter build.gradle file"
Write-Host "Please run 'flutter clean' and then 'flutter pub get' to rebuild with the patches" 