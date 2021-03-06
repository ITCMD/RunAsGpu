@echo off
cls
set this=%0
if "%~1"=="-cd" (
	set ccd2=%~2
	shift
	shift
)
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
:: COMMENT] Identifies AMD or NVIDIA
setlocal EnableDelayedExpansion
set num=0
echo Searching for Graphics Cards . . .
devcon.exe find PCI\* ^| find /i "NVIDIA" >nul 2>nul
if %errorlevel%==0 goto NVDsearch
devcon.exe find PCI\* ^| find /i "AMD" >nul 2>nul
if %errorlevel%==0 goto AMDsearch
echo No Graphics Cards Found.
echo Manual Setup in card.ini.
pause
exit /b
:: COMMENT] Lists matched cards
:AMDSEARCH
echo AMD Cards detected.
for /f "tokens=1,2,3* delims=:" %%A in ('devcon.exe find PCI\* ^| find /i "AMD"') do (
set /a num+=1
set "card!num!name=%%~B"
set "card!num!path=%%~A"
)
cls
echo [32m Please Select Your [4mPRIMARY[0;32m Card[0m
set num2=1
goto loop
:NVDSEARCH	
echo NVIDIA Cards detected.
for /f "tokens=1,2,3* delims=:" %%A in ('devcon.exe find PCI\* ^| find /i "NVIDIA"') do (
set /a num+=1
set "card!num!name=%%~B"
set "card!num!path=%%~A"
)
cls
echo [32m Please Select Your [4mPRIMARY[0;32m Card[0m
set num2=1
:: COMMENT] Displays Cards for choice
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
:: COMMENT] Saves card identifier to card.ini
for /f "tokens=1,2,3* delims=^&" %%A in ('echo "!card%cardnum%path!"') do (
	set tempvar=%%~A^^^&%%~B*
	echo %%~A^^^&%%~B*>card.ini
)
echo !card%num%name!>cardname.ini
echo Primary card set to !card%cardnum%name:~1! [90m(%tempvar%)[0m. Programs will launch on other GPU.
pause
goto launch
:launch
if not "%~1"=="" (
	set dragndrop=%1
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
echo %ccd2%>"%temp%\runascardcd"
echo %dragndrop% %2 %3>"%temp%\runascdparam"
set > log.txt
echo %this%
powershell start -verb runas -FilePath '%this%' am_admin
exit /b


:as_admin
title Run As GPU ^| Launching Program . . .
set /p ccd=<"%temp%\runascd.txt"
if not exist "%temp%\runascardcd" goto noccd2
set /p ccd2=<"%temp%\runascardcd"
for %%A in ("%ccd2%") do %%~dA >nul
cd %ccd2%
del /f /q "%temp%\runascardcd"
:noccd2
echo here
set /p params=<"%temp%\runascdparam"
set /p card=<"%ccd%\card.ini"
set /p name=<"%ccd%\cardname.ini"
echo [0mDisabling primary card [30m%name%[0m. . .[90m
call "%ccd%\devcon.exe" disable "%card%"
echo [0mLaunching program . . .[90m.
timeout /t 2 /nobreak >nul 2>nul
start "" %params%
pause
echo [0mEnablind primary card . . .[90m
call "%ccd%\devcon.exe" enable "%card%"
echo [32mComplete.[0m
echo Press any key to exit . . .
pause >nul
exit /b
