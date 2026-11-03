@echo off
title PAD SmartMap Kotabumi Selatan - Localhost Server
cls
echo ==========================================================
echo    PAD SmartMap - Bapenda Kabupaten Lampung Utara
echo ==========================================================
echo.
echo Menjalankan Web Server Localhost...
echo Halaman akan otomatis terbuka di browser Anda (http://localhost:8080).
echo.
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0server.ps1"
pause
