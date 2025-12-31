@echo off
echo Uninstalling Registry Keys...

reg delete "HKCU\Software\Classes\*\shell\FastCopyPath" /f
reg delete "HKCU\Software\Classes\Directory\shell\FastCopyPath" /f

echo.
echo Uninstallation Complete.
pause
