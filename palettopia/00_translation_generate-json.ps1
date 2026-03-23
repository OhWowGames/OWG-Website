try {
    $htmlFile = ".\index.html"
    $outputJson = ".\translation-template.json"

    # Safety check
    if (-not (Test-Path $htmlFile)) {
        throw "Cannot find '$htmlFile'. Please ensure your template is named exactly 'index.html' and is in the same folder as this script."
    }

    $html = Get-Content -Path $htmlFile -Raw -Encoding UTF8

    # 1. Extract ISO codes from custom meta tag
    $isoCodes = @()
    $langMetaRegex = '(?i)<meta[^>]+name="supported-languages"[^>]+content="([^"]+)"'
    
    if ($html -match $langMetaRegex) {
        $rawCodes = $matches[1]
        # Split by comma, trim any spaces, convert to lowercase, and ignore empty strings
        $isoCodes = $rawCodes -split ',' | ForEach-Object { $_.Trim().ToLower() } | Where-Object { $_ -ne "" }
    } else {
        throw "Could not find <meta name=`"supported-languages`" content=`"...`"> in index.html. Please add it to the <head>."
    }

    Write-Host "Found $($isoCodes.Count) languages in the supported-languages meta tag." -ForegroundColor Cyan

    # 2. Extract English text
    $englishDictionary = [ordered]@{}

    # PASS A: Extract Meta Tag Content
    $metaRegex = '(?is)<meta[^>]*data-i18n="([^"]+)"[^>]*>'
    $metaMatches = [regex]::Matches($html, $metaRegex)

    foreach ($match in $metaMatches) {
        $fullTag = $match.Value
        $key = $match.Groups[1].Value
        
        if ($fullTag -match '(?i)content="([^"]+)"') {
            $content = $matches[1]
            $englishDictionary[$key] = $content
        }
    }

    # PASS B: Extract Inner Text (handles <p>, <span>, <h1>, <title>, etc.)
    $i18nRegex = '(?is)<(?!(?:input|optgroup)\b)([a-zA-Z0-9]+)[^>]*data-i18n="([^"]+)"[^>]*>(.*?)</\1>'
    $textMatches = [regex]::Matches($html, $i18nRegex)

    foreach ($match in $textMatches) {
        $key = $match.Groups[2].Value
        $text = $match.Groups[3].Value.Trim()
        $englishDictionary[$key] = $text
    }

    # PASS C: Extract Input and Optgroup Attributes
    $inputOptRegex = '(?is)<(input|optgroup)[^>]*data-i18n="([^"]+)"[^>]*>'
    $inputOptMatches = [regex]::Matches($html, $inputOptRegex)

    foreach ($match in $inputOptMatches) {
        $fullTag = $match.Value
        $baseKey = $match.Groups[2].Value
        
        # Sequentially check for the 3 target attributes and create concatenated keys
        if ($fullTag -match '(?i)placeholder="([^"]+)"') {
            $englishDictionary["${baseKey}_placeholder"] = $matches[1]
        }
        if ($fullTag -match '(?i)value="([^"]+)"') {
            $englishDictionary["${baseKey}_value"] = $matches[1]
        }
        if ($fullTag -match '(?i)label="([^"]+)"') {
            $englishDictionary["${baseKey}_label"] = $matches[1]
        }
    }

    Write-Host "Found $($englishDictionary.Count) translatable text blocks." -ForegroundColor Cyan

    # 3. Build the master JSON structure
    $masterJson = [ordered]@{}
    foreach ($iso in $isoCodes) {
        $dictCopy = [ordered]@{}
        
        foreach ($k in $englishDictionary.Keys) {
            # If it's English, keep the text. Otherwise, leave it blank.
            if ($iso -eq "en") {
                $dictCopy[$k] = $englishDictionary[$k]
            } else {
                $dictCopy[$k] = ""
            }
        }
        
        $masterJson[$iso] = $dictCopy
    }

    # 4. Save to JSON
    $jsonOutput = $masterJson | ConvertTo-Json -Depth 4
    Set-Content -Path $outputJson -Value $jsonOutput -Encoding UTF8

    Write-Host "`nSuccessfully generated: $outputJson" -ForegroundColor Green
}
catch {
    # If anything breaks, print the exact error message in red
    Write-Host "`n[ERROR] The script encountered a problem:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow
    Write-Host "Details: $($_.InvocationInfo.PositionMessage)" -ForegroundColor DarkGray
}
finally {
    # This ensures the window stays open no matter what
    Write-Host "`nPress Enter to close this window..." -ForegroundColor Cyan
    Read-Host
}