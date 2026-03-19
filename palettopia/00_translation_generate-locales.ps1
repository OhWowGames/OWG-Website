try {
    $htmlFile = ".\index.html"
    $jsonFile = ".\translation-complete.json"
    $outputDir = ".\"
    $baseUrl = "https://ohwow.games/palettopia/"

    # Safety checks
    if (-not (Test-Path $htmlFile)) { throw "Cannot find '$htmlFile'." }
    if (-not (Test-Path $jsonFile)) { throw "Cannot find '$jsonFile'. Have you renamed your translated file to match this script?" }

    $htmlTemplate = Get-Content -Path $htmlFile -Raw -Encoding UTF8
    $translations = Get-Content -Path $jsonFile -Raw -Encoding UTF8 | ConvertFrom-Json

    if (-not (Test-Path -Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir | Out-Null }

    # Start generating the XML Sitemap
    $sitemapXml = "<?xml version=`"1.0`" encoding=`"UTF-8`"?>`r`n"
    $sitemapXml += "<urlset xmlns=`"http://www.sitemaps.org/schemas/sitemap/0.9`" xmlns:xhtml=`"http://www.w3.org/1999/xhtml`">`r`n"

    # Get all ISO codes from the JSON
    $isoCodes = $translations.psobject.properties.Name

    foreach ($iso in $isoCodes) {
        $targetDir = Join-Path -Path $outputDir -ChildPath $iso
        if (-not (Test-Path -Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir | Out-Null }
        
        $currentHtml = $htmlTemplate
        $langData = $translations.$iso
        
        # 1. Update the HTML Lang attribute
        $currentHtml = $currentHtml -replace '(?i)(<html[^>]+lang=")[^"]+(")', "`$1$iso`$2"

        # 1. Update the meta content-language attribute
        $currentHtml = $currentHtml -replace '(?i)(<[^>]+content-language[^>]+content=")[^"]+(")', "`$1$iso`$2"
        
        # 2-1. Update the Canonical Tag
        if ($iso -ne "en") {
            $currentHtml = $currentHtml.Replace("rel=`"canonical`" href=`"$baseUrl`"", "rel=`"canonical`" href=`"$baseUrl$iso/`"")
        }
        # 2-2. Update the Base URL
        $currentHtml = $currentHtml.Replace("base href=`"../`"", "base href=`"../../`"")
        
        # 3. Swap the Text Content
        foreach ($prop in $langData.psobject.properties) {
            $key = $prop.Name
            $translatedText = $prop.Value
            
            # PASS C: Check if this is an input/optgroup attribute key
            if ($key -match '^(.*)_(placeholder|value|label)$') {
                $baseKey = $matches[1]
                $attrName = $matches[2]
                $escapedBaseKey = [regex]::Escape($baseKey)

                # Target the exact input or optgroup tag
                $attrTargetRegex = '(?is)(<(input|optgroup)[^>]*data-i18n="' + $escapedBaseKey + '"[^>]*>)'
                if ($currentHtml -match $attrTargetRegex) {
                    $currentHtml = [regex]::Replace($currentHtml, $attrTargetRegex, {
                        param($m)
                        # Swap only the specific attribute's value inside the tag
                        $m.Value -replace "(?i)$attrName=`"[^`"]*`"", "$attrName=`"$translatedText`""
                    })
                }
                # Skip the rest of the loop so it doesn't process this as a normal tag
                continue 
            }
            
            # Standard tags (PASS A & PASS B)
            $escapedKey = [regex]::Escape($key)
            
            # PASS A: Swap Inner Text
            $replaceInnerRegex = '(?is)(<([a-zA-Z0-9]+)[^>]*data-i18n="' + $escapedKey + '"[^>]*>)(.*?)(</\2>)'
            if ($currentHtml -match $replaceInnerRegex) {
                # Note: Using ${1} and ${4} to prevent numbers from merging with capture groups
                $currentHtml = $currentHtml -replace $replaceInnerRegex, ("`${1}" + $translatedText + "`${4}")
            }
            
            # PASS B: Swap Meta Tag Content
            $metaTargetRegex = '(?is)(<meta[^>]*data-i18n="' + $escapedKey + '"[^>]*>)'
            if ($currentHtml -match $metaTargetRegex) {
                $currentHtml = [regex]::Replace($currentHtml, $metaTargetRegex, {
                    param($m)
                    $m.Value -replace '(?i)content="[^"]+"', "content=`"$translatedText`""
                })
            }
        }
        
        # 4. Save the localized HTML
        $outputPath = Join-Path -Path $targetDir -ChildPath "index.html"
        Set-Content -Path $outputPath -Value $currentHtml -Encoding UTF8
        
        # 5. Build Sitemap Block
        $sitemapXml += "`t<url>`r`n`t`t<loc>$baseUrl$(if ($iso -eq 'en') { '' } else { "$iso/" })</loc>`r`n"
        $sitemapXml += "`t`t<xhtml:link rel=`"alternate`" hreflang=`"x-default`" href=`"$baseUrl`" />`r`n"
        foreach ($altIso in $isoCodes) {
            $sitemapXml += "`t`t<xhtml:link rel=`"alternate`" hreflang=`"$altIso`" href=`"$baseUrl$(if ($altIso -eq 'en') { '' } else { "$altIso/" })`" />`r`n"
        }
        $sitemapXml += "`t</url>`r`n"
        
        Write-Host "Built localized page for: $iso" -ForegroundColor Cyan
    }

    # Finish and save Sitemap
    $sitemapXml += "</urlset>"
    $sitemapPath = Join-Path -Path $outputDir -ChildPath "sitemap.xml"
    Set-Content -Path $sitemapPath -Value $sitemapXml -Encoding UTF8

    Write-Host "`nSuccess! Site and sitemap built in $outputDir" -ForegroundColor Green
}
catch {
    Write-Host "`n[ERROR] The script encountered a problem:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow
    Write-Host "Details: $($_.InvocationInfo.PositionMessage)" -ForegroundColor DarkGray
}
finally {
    Write-Host "`nPress Enter to close this window..." -ForegroundColor Cyan
    Read-Host
}