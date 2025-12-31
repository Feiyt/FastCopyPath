@echo off
chcp 65001 >nul
setlocal

echo 正在切换为纯注册表模式 (无需exe文件)...

REM 定义菜单名称
set "MENU_NAME=FastCopyPath"

REM 定义执行命令 (使用系统自带 cmd 和 clip)
REM 注意: cmd /c echo %%1 | clip 会将路径复制到剪贴板
set "CMD_STR=cmd /c echo %%1| clip"

REM 1. 清理旧的 C++ 版本注册表
reg delete "HKCU\Software\Classes\*\shell\FastCopyPath" /f >nul 2>&1
reg delete "HKCU\Software\Classes\Directory\shell\FastCopyPath" /f >nul 2>&1

REM 2. 添加文件右键菜单
reg add "HKCU\Software\Classes\*\shell\FastCopyPath" /ve /d "%MENU_NAME%" /f
REM 使用系统自带剪贴板图标
reg add "HKCU\Software\Classes\*\shell\FastCopyPath" /v "Icon" /d "shell32.dll,242" /f
reg add "HKCU\Software\Classes\*\shell\FastCopyPath\command" /ve /d "%CMD_STR%" /f

REM 3. 添加文件夹右键菜单
reg add "HKCU\Software\Classes\Directory\shell\FastCopyPath" /ve /d "%MENU_NAME%" /f
reg add "HKCU\Software\Classes\Directory\shell\FastCopyPath" /v "Icon" /d "shell32.dll,242" /f
reg add "HKCU\Software\Classes\Directory\shell\FastCopyPath\command" /ve /d "%CMD_STR%" /f

echo.
echo [成功] 已切换为纯注册表模式！
echo 您现在可以删除 bin 文件夹和 src 文件夹了。
pause