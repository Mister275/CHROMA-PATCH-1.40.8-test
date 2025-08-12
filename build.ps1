param()
Write-Host "Starting Chroma build script..."
$solution = "./src/Chroma.sln"
$outputDir = "./output"
if (!(Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir | Out-Null }
$dumpUrl = $env:BS_1408_DUMP_URL
if ($dumpUrl -and !(Test-Path "./libs/Assembly-CSharp.dll")) {
    Write-Host "Attempting to download public 1.40.8 dump from $dumpUrl"
    Invoke-WebRequest -Uri $dumpUrl -OutFile "./libs/Assembly-CSharp.dll"
}
& msbuild $solution /p:Configuration=Release /m
$built = Get-ChildItem -Path ./src -Filter Chroma.dll -Recurse | Select-Object -First 1
if ($built) {
    Copy-Item $built.FullName -Destination (Join-Path $outputDir 'Chroma.dll') -Force
    Write-Host "Build succeeded. Artifact at $outputDir\Chroma.dll"
} else {
    Write-Error "Build failed: Chroma.dll not found"
    exit 1
}
