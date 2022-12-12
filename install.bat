@shift /0
@echo OFF
title Pixel Experience installer
SETLOCAL ENABLEDELAYEDEXPANSION
cls
:ZIP_FILES
echo.
echo.
echo          -------------------------------------------
echo          -------------------------------------------
echo.
echo              Select the zip file with a number
echo.
echo          -------------------------------------------
echo          -------------------------------------------
echo.
SET /A i=1
FOR %%k IN (*.zip) DO (
	SET ZIP!i!=%%k
	echo *          !i! - %%k
	SET /A i+=1
)
echo.
echo.
SET /P NUMBER=*          Select a number: 
IF NOT DEFINED NUMBER GOTO :ZIP_FILES
IF /I %NUMBER% GEQ %i% GOTO :ZIP_FILES
IF /I %NUMBER% LSS 1 GOTO :ZIP_FILES
SET FILE=!ZIP%NUMBER%!
IF NOT EXIST "%FILE%" GOTO :ZIP_FILES

fastboot devices
fastboot %* flash vendor_boot_a bin\vendor_boot.img || @echo "Flash vendor_boot_a error" && exit /B 1
fastboot %* flash vendor_boot_b bin\vendor_boot.img || @echo "Flash vendor_boot_b error" && exit /B 1
fastboot %* flash boot_a bin\boot.img || @echo "Flash boot_a error" && exit /B 1
fastboot %* flash boot_b bin\boot.img || @echo "Flash boot_b error" && exit /B 1
fastboot %* reboot recovery


:sideload
pause
adb devices
adb sideload %FILE%
echo.
echo turn your device into bootloader
echo.
pause
fastboot %* flash uefisecapp_a bin\uefisecapp.img || @echo "Flash uefisecapp_a error" && exit /B 1
fastboot %* flash uefisecapp_b bin\uefisecapp.img || @echo "Flash uefisecapp_b error" && exit /B 1
fastboot %* flash xbl_a bin\xbl.img || @echo "Flash xbl_a error" && exit /B 1
fastboot %* flash xbl_b bin\xbl.img || @echo "Flash xbl_b error" && exit /B 1
fastboot %* flash xbl_config_a bin\xbl_config.img || @echo "Flash xbl_config_a error" && exit /B
fastboot %* flash xbl_config_b bin\xbl_config.img || @echo "Flash xbl_config_b error" && exit /B 1
fastboot %* flash logo bin\logo.img || @echo "Flash logo error" && exit /B 1
fastboot %* reboot recovery


:EOL
echo Tasking Completed
pause