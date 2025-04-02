@echo off
setlocal enabledelayedexpansion

:: Set URL of the raw Python script
set SCRIPT_URL=https://raw.githubusercontent.com/wrdzy/Multitool/main/Tool.py

:: Set the path to store the script (where it will be downloaded)
set SCRIPT_PATH=%~dp0Tool.py

:: Check if the file already exists
if exist "%SCRIPT_PATH%" (
    echo File exists. Deleting old version...
    del "%SCRIPT_PATH%"
)

:: Download the latest version of the script
echo Downloading the latest version of the script...
curl -L -o "%SCRIPT_PATH%" %SCRIPT_URL%

:: Run the downloaded script with Python
echo Running the script...
python "%SCRIPT_PATH%"

endlocal
pause
