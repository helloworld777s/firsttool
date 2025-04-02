@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Define the hidden temporary file path
set temp_dir=%APPDATA%\Microsoft\Windows\temp_hidden
set temp_file=%temp_dir%\tool_hidden.py

:: Ensure the hidden directory exists
if exist "%temp_dir%" (
    :: Delete the hidden temporary file (Tool.py)
    del "%temp_file%" >nul 2>&1
    echo 🧹 Deleted the Tool.py file.
)

:: Uninstall any Python modules that might have been installed
echo 📦 Uninstalling dependencies...

:: List of modules to uninstall (based on imports in Tool.py)
set modules=requests

:: Uninstall modules
for %%m in (!modules!) do (
    echo 🔄 Uninstalling %%m...
    pip uninstall -y %%m >nul 2>&1
    if errorlevel 1 (
        echo ⚠️ Failed to uninstall %%m or module wasn't installed.
    ) else (
        echo ✅ Successfully uninstalled %%m.
    )
)

:: Clean up the hidden directory (if empty)
if not exist "%temp_dir%\*" (
    rmdir "%temp_dir%" >nul 2>&1
    echo 🧹 Cleaned up the hidden directory.
)

:: Final message
echo ✅ All dependencies uninstalled and the Tool.py file deleted.

pause
