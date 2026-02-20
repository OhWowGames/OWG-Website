# Set location to the folder where this script is saved
Set-Location -Path $PSScriptRoot

# Get all video files using -Filter (more reliable and faster)
# We use a simple loop to catch multiple extensions if needed
$extensions = "*.mp4", "*.mkv", "*.mov", "*.avi"
$videos = Get-ChildItem -Path . -File | Where-Object { $_.Extension -match '\.(mp4|mkv|mov|avi)$' }

$total = $videos.Count
$current = 1

if ($total -eq 0) {
    Write-Host "No video files found in: $PSScriptRoot" -ForegroundColor Red
    Write-Host "Make sure the .mp4 files are in the SAME folder as this script." -ForegroundColor Gray
} else {
    foreach ($file in $videos) {
        $output = Join-Path $PSScriptRoot "$($file.BaseName).webm"
        
        Write-Host "`n--------------------------------------------------" -ForegroundColor Cyan
        Write-Host "Processing ($current of $total): $($file.Name)" -ForegroundColor Yellow
        
        # FFmpeg Command: No audio (-an), 2M bitrate, speed optimized
        ffmpeg -i "$($file.FullName)" `
               -c:v libvpx-vp9 -crf 34 -b:v 0 -speed 0 `
               -an -y `
               "$output"
               
        $current++
    }
    Write-Host "`nAll conversions complete!" -ForegroundColor Green
}

# Wait for user input before closing
Write-Host "`nPress any key to exit..." -ForegroundColor White
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
