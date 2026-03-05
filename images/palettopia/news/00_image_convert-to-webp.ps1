# Set location to the folder where this script is saved
Set-Location -Path $PSScriptRoot

# Get all common image files using a regex match
# Added support for png, webp, bmp, tiff, and heic
$images = Get-ChildItem -Path . -File | Where-Object { $_.Extension -match '\.(png|bmp|tiff|heic|jpeg|jpg)$' }

$total = $images.Count
$current = 1

if ($total -eq 0) {
    Write-Host "No image files found in: $PSScriptRoot" -ForegroundColor Red
    Write-Host "Make sure the images are in the SAME folder as this script." -ForegroundColor Gray
} else {
    foreach ($file in $images) {
        $output = Join-Path $PSScriptRoot "$($file.BaseName)_720.webp"
        
        Write-Host "`n--------------------------------------------------" -ForegroundColor Cyan
        Write-Host "Processing ($current of $total): $($file.Name)" -ForegroundColor Yellow
        
        # FFmpeg Command for Images:
        # -q:v 2 (High quality Jpeg, scale is 1-31, lower is better)
        ffmpeg -i "$($file.FullName)" `
               -q:v 82 `
	       -vf "scale=-1:720" `
               -y `
               "$output"
               
        $current++
    }
    Write-Host "`nAll image conversions complete!" -ForegroundColor Green
}

# Wait for user input before closing
# Write-Host "`nPress any key to exit..." -ForegroundColor White
# $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")