@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Define the correct raw URL of the Python script on GitHub
set file_url=https://raw.githubusercontent.com/helloworld777s/firsttool/main/Tool%20%231/Tool.py

:: Get the current folder where the batch file is located
set script_dir=%~dp0

:: Define the path to save the Python script in the same folder
set temp_file=%script_dir%Tool.py

:: Check if the file already exists
if exist "%temp_file%" (
    echo 🧑‍💻 Checking for a newer version of Tool.py...

    :: Fetch the raw Python script content and compare it with the current version
    curl -sL --etag-compare "%file_url%" > nul
    if %errorlevel% neq 0 (
        echo ✨ New version detected. Downloading the latest version...
        curl -sL %file_url% -o "%temp_file%"
    ) else (
        echo ✅ Tool.py is up to date. Skipping download.
    )
) else (
    echo 🧑‍💻 Tool.py not found. Downloading the latest version...
    curl -sL %file_url% -o "%temp_file%"
)

:: Check if fetching the content was successful
if not exist "%temp_file%" (
    echo ❌ Failed to fetch Tool.py content. Please check the URL.
    pause
    exit /b
)

:: Run the downloaded Python script with Python
echo 🏃‍♂️ Running the Tool.py script...
python "%temp_file%"

pause
