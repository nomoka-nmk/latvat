try {
    $installDir = "$env:TEMP\nmkserver-install"
    Write-Host "[INFO] Creating folder: $installDir"
    New-Item -Path $installDir -ItemType Directory -Force | Out-Null
    Set-Location $installDir

    $javaInstaller = "OpenJDK21U-jre_x64_windows_hotspot_21.0.7_6.msi"
    $javaUrl = "https://objects.githubusercontent.com/github-production-release-asset-2e65be/602574963/bb090a23-7d19-4e3e-9005-31a185eaf4dd?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20250705%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250705T190834Z&X-Amz-Expires=1800&X-Amz-Signature=b6e37da8f7f7694fe85971084ed4914d77619a1c4b19191efc83d2f0577a56b5&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3DOpenJDK21U-jre_x64_windows_hotspot_21.0.7_6.msi&response-content-type=application%2Foctet-stream"
    Write-Host "[INFO] Downloading Java from $javaUrl"
    Invoke-WebRequest -Uri $javaUrl -OutFile $javaInstaller
    Write-Host "[INFO] Installing Java..."
    Start-Process msiexec.exe -ArgumentList "/i `"$javaInstaller`" -passive" -Wait
    Write-Host "[INFO] Java installation complete."

    $repo = "PolyMC/PolyMC"
    $filePattern = "PolyMC-Windows-Setup"
    $apiUrl = "https://api.github.com/repos/$repo/releases/latest"
    Write-Host "[INFO] Fetching latest release info from GitHub..."
    $release = Invoke-RestMethod -Uri $apiUrl -Headers @{ "User-Agent" = "custom"; "Accept" = "application/vnd.github.v3+json" }

    $asset = $release.assets | Where-Object { $_.name -like "*$filePattern*" -and $_.name -like "*.exe" } | Select-Object -First 1
    if ($asset -ne $null) {
        $downloadUrl = $asset.browser_download_url
        $installerPath = "latest-installer.exe"
        Write-Host "[INFO] Downloading latest PolyMC setup..."
        Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath
        Write-Host "[DONE] PolyMC installer downloaded: $installerPath"

        Write-Host "[INFO] Launching installer..."
        Start-Process -FilePath $installerPath

        Start-Sleep -Seconds 5
        Write-Host "[INFO] Installer launched. Press any key to continue cleanup."
        Pause

    } else {
        throw "[ERROR] Could not find matching installer in release assets."
    }
} catch {
    Write-Host $_ -ForegroundColor Red
    Write-Host "[FATAL] Installation script failed. Please check logs or internet connection."
}
