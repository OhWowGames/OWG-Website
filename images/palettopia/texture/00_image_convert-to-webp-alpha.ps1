# Set location to the folder where this script is saved
Set-Location -Path $PSScriptRoot

# Get all common image files
$images = Get-ChildItem -Path . -File | Where-Object { $_.Extension -match '\.(png|bmp|tiff|heic|jpeg|jpg)$' }

$total = $images.Count
$current = 1

if ($total -eq 0) {
    Write-Host "No image files found in: $PSScriptRoot" -ForegroundColor Red
} else {
    foreach ($file in $images) {
        $output = Join-Path $PSScriptRoot "$($file.BaseName).webp"
        
        Write-Host "`n--------------------------------------------------" -ForegroundColor Cyan
        Write-Host "Processing ($current of $total): $($file.Name)" -ForegroundColor Yellow
        
        # FFmpeg Command for WebP:
        # -lossless 0 (Enables lossy compression, use 1 for perfect PNG clones)
        # -compression_level 6 (Good balance of speed vs file size)
        # -q:v 82 (Your requested quality setting)
        ffmpeg -i "$($file.FullName)" `
               -vcodec libwebp `
               -lossless 0 `
               -compression_level 6 `
               -q:v 82 `
               -y `
               "$output"
               
        $current++
    }
    Write-Host "`nAll image conversions complete!" -ForegroundColor Green
}

#Write-Host "`nPress any key to exit..." -ForegroundColor White
#$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")