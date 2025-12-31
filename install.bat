@echo off
chcp 65001 >nul
setlocal

REM Get the directory of this script
set "SCRIPT_DIR=%~dp0"
set "EXE_PATH=%SCRIPT_DIR%bin\FastCopyPath.exe"

REM Build the project if source exists (Development Mode)
if exist "%SCRIPT_DIR%src\main.cpp" (
    echo Found source code. Building...
    
    REM Check for icon file before building
    if not exist "%SCRIPT_DIR%src\app.ico" (
        echo [ERROR] Icon file missing!
        echo Please place your icon file at: %SCRIPT_DIR%src\app.ico
        echo Then run this script again.
        pause
        exit /b 1
    )

    if not exist "%SCRIPT_DIR%bin" mkdir "%SCRIPT_DIR%bin"
    
    echo Compiling Resources...
    windres "%SCRIPT_DIR%src\app.rc" -o "%SCRIPT_DIR%src\app.o"
    
    echo Compiling Application...
    g++ "%SCRIPT_DIR%src\main.cpp" "%SCRIPT_DIR%src\app.o" -o "%SCRIPT_DIR%bin\FastCopyPath.exe" -mwindows -municode -static -O2
    
    if %errorlevel% neq 0 (
        echo Build failed. Aborting installation.
        pause
        exit /b 1
    )
    echo Build successful!
)

if not exist "%EXE_PATH%" (
    echo Executable not found at %EXE_PATH%
    pause
    exit /b 1
)

echo Installing Registry Keys...

REM File Context Menu
reg add "HKCU\Software\Classes\*\shell\FastCopyPath" /ve /d "复制路径" /f
reg add "HKCU\Software\Classes\*\shell\FastCopyPath" /v "Icon" /d "\"%EXE_PATH%\",0" /f
reg add "HKCU\Software\Classes\*\shell\FastCopyPath\command" /ve /d "\"%EXE_PATH%\" \"%%1\"" /f

REM Directory Context Menu
reg add "HKCU\Software\Classes\Directory\shell\FastCopyPath" /ve /d "复制路径" /f
reg add "HKCU\Software\Classes\Directory\shell\FastCopyPath" /v "Icon" /d "\"%EXE_PATH%\",0" /f
reg add "HKCU\Software\Classes\Directory\shell\FastCopyPath\command" /ve /d "\"%EXE_PATH%\" \"%%1\"" /f

echo.
echo Installation Complete!
echo You can now right-click any file or folder and select "复制路径".
pause
