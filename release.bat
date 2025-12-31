@echo off
chcp 65001 >nul
setlocal

echo Creating distribution package...

REM Create dist directory
if exist "dist" rd /s /q "dist"
mkdir "dist"
mkdir "dist\bin"
mkdir "dist\src"

REM Build the project to ensure latest version
echo Compiling...
if not exist "bin" mkdir bin
windres src/app.rc -o src/app.o
g++ src/main.cpp src/app.o -o bin/FastCopyPath.exe -mwindows -municode -static -O2

if %errorlevel% neq 0 (
    echo Build failed. Cannot create release.
    pause
    exit /b 1
)

REM Copy files
echo Copying files...
copy "install.bat" "dist\" >nul
copy "uninstall.bat" "dist\" >nul
copy "reg_only.bat" "dist\" >nul
copy "README.md" "dist\" >nul
copy "bin\FastCopyPath.exe" "dist\bin\" >nul
copy "src\app.ico" "dist\src\" >nul

echo.
echo Release package created in "dist" folder!
echo You can now zip the "dist" folder and send it to other computers.
echo On the other computer, just unzip and run "install.bat".
echo.
pause