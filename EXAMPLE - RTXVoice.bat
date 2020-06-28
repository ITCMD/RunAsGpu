@echo off
echo Launching RTX Voice on secondary GPU . . .
timeout /t 1 /nobreak >nul 2>nul
cd "C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice\"
call runascard -cd "C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice\" "C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice\NVIDIA RTX Voice.exe"
exit /b
