@echo off
REM ===================================================
REM  KSP AHNRFZI - Aktifkan auto-start tiap login Windows
REM  Klik 2x file ini SATU KALI saja.
REM ===================================================
cd /d %~dp0
set "TARGET=%CD%\start_server.bat"
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

echo Membuat shortcut autostart...
powershell -NoProfile -Command "$w=New-Object -ComObject WScript.Shell; $s=$w.CreateShortcut(\"$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\KSP AHNRFZI.lnk\"); $s.TargetPath='%TARGET%'; $s.WorkingDirectory='%CD%'; $s.Description='KSP AHNRFZI Server Autostart'; $s.Save(); Write-Host 'OK:' $s.FullName"

echo.
echo Selesai. Mulai sekarang tiap login Windows, server + browser login
echo http://127.0.0.1:8000/login terbuka otomatis.
echo Untuk mematikan: hapus file "KSP AHNRFZI.lnk" di folder Startup.
pause
