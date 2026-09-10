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
        Write-Host "`n--------------------------------------------------" -ForegroundColor Cyan
        Write-Host "Processing ($current of $total): $($file.Name)" -ForegroundColor Yellow
        
        # FFmpeg Command: No audio (-an) frame rate(-r 60) (webm -c:v libvpx-vp9 -crf 34) (mp4 -crf 21) (only render 1 frame -vframes 1) (-vf "crop=1215:2160:0:0") (-vf "scale=trunc(oh*a/2)*2:1440")
                
        $output = Join-Path $PSScriptRoot "\output\$($file.BaseName)_720.mp4"
        ffmpeg -y -fflags +genpts -i "$($file.FullName)" `
                -c:v libx264 -preset veryslow -pix_fmt yuv420p -movflags +faststart -map_metadata 0 `
	       	    -an -vf "scale=-2:720" -r 30 -t 13.2 -crf 21 `
               "$output"
        
        $output = Join-Path $PSScriptRoot "\output\$($file.BaseName)_1080.mp4"
        ffmpeg -y -fflags +genpts -i "$($file.FullName)" `
                -c:v libx264 -preset veryslow -pix_fmt yuv420p -movflags +faststart -map_metadata 0 `
	       	    -an -vf "scale=-2:1080" -r 30 -t 13.2 -crf 21 `
               "$output"

        $output = Join-Path $PSScriptRoot "\output\$($file.BaseName)_720.webm"
        ffmpeg -y -fflags +genpts -i "$($file.FullName)" `
                -c:v libvpx-vp9 -b:v 0 -speed 0 -map_metadata 0 `
	       	    -an -vf "scale=-2:720" -r 30 -t 13.2 -crf 34 `
               "$output"
        
        $output = Join-Path $PSScriptRoot "\output\$($file.BaseName)_1080.webm"
        ffmpeg -y -fflags +genpts -i "$($file.FullName)" `
                -c:v libvpx-vp9 -b:v 0 -speed 0 -map_metadata 0 `
	       	    -an -vf "scale=-2:1080" -r 30 -t 13.2 -crf 34 `
               "$output"
        
        $output = Join-Path $PSScriptRoot "\output\$($file.BaseName)_1080.webp"
        ffmpeg -y -i "$($file.FullName)" -vframes 1 -vf "scale=-2:1080" -q:v 82 "$output"
               
        $current++
    }
    Write-Host "`nAll conversions complete!" -ForegroundColor Green
}

# Wait for user input before closing
 Write-Host "`nPress any key to exit..." -ForegroundColor White
 $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
