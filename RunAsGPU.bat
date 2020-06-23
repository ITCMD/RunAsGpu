@echo off
cls
if "%~1"=="am_admin" (
	goto as_admin
)
title Run on Secondary GPU ^| by SetLucas ^| github.com/ITCMD
:: COMMENT] Finds devcon.exe and puts it in same dir
if not exist "%cd%\devcon.exe" (
	if exist "C:\Program Files (x86)\Windows Kits\10\Tools\x64\devcon.exe" (
		copy "C:\Program Files (x86)\Windows Kits\10\Tools\x64\devcon.exe" "%cd%\devcon.exe" >nul
	) ELSE (
		echo No Devcon File Was found.
		echo Install it or download it at
		echo https://drive.google.com/file/d/1y3xF30E-vRHeFX5U5DpdZ312P0cGDj2-/view?usp=sharing
	)
)
:: COMMENT] Checks if card is already identified.
if exist card.ini (
	set /p card=<card.ini
	goto launch
)
:: COMMENT] Identifies cards
setlocal EnableDelayedExpansion
set num=0
for /f "tokens=1,2,3* delims=:" %%A in ('devcon.exe find PCI\* ^| find /i "NVIDIA"') do (
set /a num+=1
set "card!num!name=%%~B"
set "card!num!path=%%~A"
)
cls
echo [32m Please Select Your [4mPRIMARY[0;32m Card[0m
set num2=1
:loop
echo %num2%] !card%num2%name:~1!
if "%num2%"=="%num%" goto endloop
set /a num2+=1
goto loop
:endloop
set /p cardnum=">"
if "!card%cardnum%name!"=="" (
	echo Invalid Selection.
	goto endloop
)
for /f "tokens=1,2,3* delims=^&" %%A in ('echo "!card%cardnum%path!"') do (
	echo %%~A^^^&%%~B*>card.ini
)
echo Primary card set to !card%cardnum%name:~1!. Programs will launch on other GPU.
pause
goto launch
:launch
if not "%~1"=="" (
	set dragndrop=%~1
	goto runas
)
echo [32mDrag And Drop program to run here:[0m
set /p dragndrop=">"
:runas
if not exist %dragndrop% (
	echo Windows could not find %dragndrop%.
	echo Please make sure you have quotes around your entry if there are
	echo spaces, and that your program exists.
	pause
	goto launch
)
::set dragndrop=%dragndrop:(=`(%
::set dragndrop=%dragndrop:)=`^)%
cd>"%temp%\runascd.txt"
echo %dragndrop% %2 %3>"%temp%\runascdparam"
powershell start -verb runas -FilePath '%0' am_admin
exit /b
if "%~2"=="" (
	powershell start -verb runas -FilePath '%0' am_admin '%dragndrop%'
) ELSE (
	if "%~3"=="" (
		powershell start -verb runas '%0' am_admin %dragndrop% %2
	) ELSE (
		powershell start -verb runas '%0' am_admin %dragndrop% %2 %3
	)
)
exit /b
rem powershell start -verb runas '%0' am_admin %1


:as_admin
set /p ccd=<"%temp%\runascd.txt"
for %%A in ("%ccd%") do %%~dA >nul
cd %ccd%
set /p params=<"%temp%\runascdparam"
set /p card=<card.ini
echo [0mDisabling primary card . . .[90m
call devcon.exe disable "%card%"
echo | set /p="[0mLaunching program . . .[90m."
timeout /t 4 /nobreak >nul 2>nul
start "" %params%
timeout /t 4 /nobreak
echo [0mEnablind primary card . . .[90m
call devcon.exe enable "%card%"
echo [32mComplete.[0m
echo Press any key to exit . . .
pause >nul
exit /b
