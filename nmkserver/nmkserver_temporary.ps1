try {
    $installDir = "$env:TEMP\nmkserver-install"
    Write-Host "[INFO] Creating folder: $installDir"
    Set-Location $installDir

    $javaInstaller = "zulu21.42.19-ca-jdk21.0.7-win_x64.msi"
    $javaUrl = "https://cdn.azul.com/zulu/bin/zulu21.42.19-ca-jdk21.0.7-win_x64.msi"
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
