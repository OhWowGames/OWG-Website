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
        $output = Join-Path $PSScriptRoot "$($file.BaseName)_720.mp4"
        
        Write-Host "`n--------------------------------------------------" -ForegroundColor Cyan
        Write-Host "Processing ($current of $total): $($file.Name)" -ForegroundColor Yellow
        
        # FFmpeg Command: No audio (-an)frame rate(-r 60) (webm -c:v libvpx-vp9 -crf 34) (mp4 -crf 21) (only render 1 frame -vframes 1) (-vf "crop=1215:2160:0:0") (-vf "scale=trunc(oh*a/2)*2:1440")

        ffmpeg -i "$($file.FullName)" `
               	-crf 21 -b:v 0 -speed 0 `
               	-y -an -r 30 `
		-map_metadata 0 -fflags +genpts `
	       	-vf "scale=trunc(oh*a/2)*2:720" `
               "$output"
               
        $current++
    }
    Write-Host "`nAll conversions complete!" -ForegroundColor Green
}

# Wait for user input before closing
 Write-Host "`nPress any key to exit..." -ForegroundColor White
 $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
