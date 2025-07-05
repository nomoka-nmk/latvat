@echo off
setlocal enabledelayedexpansion

set "install_dir=%temp%\nmkserver-install"

echo [INFO] Removing old folder: %install_dir%
if exist "%install_dir%" (
    del /f /s /q "%install_dir%\*"
    rmdir /s /q "%install_dir%"
) else (
    echo [WARN] Old folder not found, skipping deletion.
)

echo [INFO] Creating folder: %install_dir%
mkdir "%install_dir%" || echo [ERROR] Failed to create folder! && exit /b 1
cd /d "%install_dir%" || echo [ERROR] Failed to change to folder! && exit /b 1

echo [INFO] Downloading PowerShell script...
curl -s -L "https://raw.githubusercontent.com/nomoka-nmk/latvat/refs/heads/main/nmkserver/nmkserver_polymcwithjava21.ps1" -o nmkserver_polymcwithjava21.ps1

if not exist "nmkserver_polymcwithjava21.ps1" (
    echo [ERROR] Failed to download the script file!
    exit /b 1
)

echo [INFO] Executing PowerShell script with error handling
powershell -ExecutionPolicy Bypass -Command ^
    try { .\nmkserver_polymcwithjava21.ps1 } ^
    catch { Write-Host "[ERROR] An error occurred while running PowerShell script:`n$_"; exit 1 }

timeout /t 5 >nul

echo [INFO] Cleaning up downloaded file
echo [INFO] Removing old folder: %install_dir%
if exist "%install_dir%" (
    del /f /s /q "%install_dir%\*"
    rmdir /s /q "%install_dir%"
) else (
    echo [WARN] Old folder not found, skipping deletion.
)

echo [INFO] All done! Have a good day!
pause
