@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Define the URL of the Tool.py file on GitHub
set file_url=https://raw.githubusercontent.com/helloworld777s/firsttool/main/Tool%20%231/Tool.py

:: Define a hidden temporary file path
set temp_dir=%APPDATA%\Microsoft\Windows\temp_hidden
set temp_file=%temp_dir%\tool_hidden.py

:: Ensure the hidden directory exists
if not exist "%temp_dir%" mkdir "%temp_dir%"
attrib +h "%temp_dir%" >nul 2>&1

:: Fetch the raw Tool.py content using curl and save it in a hidden file
echo 🧑‍💻 Fetching Tool.py from GitHub...
curl -s %file_url% > "%temp_file%"

:: Mark the file as hidden
attrib +h "%temp_file%" >nul 2>&1

:: Check if fetching the content was successful
if not exist "%temp_file%" (
    echo ❌ Failed to fetch Tool.py content. Please check the URL.
    pause
    exit /b
)

:: Initialize variables
set modules=
set total_modules=0
set current_module=0

:: Parse Tool.py for import statements and extract module names
echo 📄 Extracting module names from Tool.py...
for /f "tokens=2 delims= " %%a in ('findstr /r "^import " "%temp_file%"') do (
    :: Skip comments and empty lines
    if "%%a" neq "" (
        set modules=!modules! %%a
        set /a total_modules+=1
    )
)

:: If no modules were found, exit the script
if "!modules!"=="" (
    echo ❌ No import statements found in Tool.py!
    pause
    exit /b
)

echo 📦 Checking dependencies...

:: Ensure pip is up to date
echo 🔍 Updating pip...
python -m pip install --upgrade pip >nul 2>&1

echo 🔄 Installing/Verifying Modules:
echo.

set all_installed=true

:: Install the modules
for %%m in (!modules!) do (
    set /a current_module+=1
    set /a percentage=!current_module! * 100 / !total_modules!
    
    :: Calculate the filled and empty portions of the progress bar
    set /a filled=!percentage! / 5
    set /a empty=20-!filled!
    
    :: Build the progress bar string
    set progressbar= 
    for /l %%i in (1,1,!filled!) do set progressbar=!progressbar!█
    for /l %%i in (1,1,!empty!) do set progressbar=!progressbar!░
    
    :: Clear the line and print the new progress bar
    cls
    echo 📦 Checking dependencies...
    echo 🔍 Updating pip...
    echo 🔄 Installing/Verifying Modules:
    echo.
    echo [!progressbar!] !percentage!%% Checking %%m...

    :: Check if module is installed
    python -c "import %%m" 2>nul || (
        set all_installed=false
        
        :: Clear and update for installation message
        cls
        echo 📦 Checking dependencies...
        echo 🔍 Updating pip...
        echo 🔄 Installing/Verifying Modules:
        echo.
        echo [!progressbar!] !percentage!%% Installing %%m...
        
        :: Try to install the module and check if successful
        pip install %%m >nul 2>&1
        if errorlevel 1 (
            :: Module installation failed, skipping this module
            cls
            echo 📦 Checking dependencies...
            echo 🔍 Updating pip...
            echo 🔄 Installing/Verifying Modules:
            echo.
            echo [!progressbar!] !percentage!%% Failed to install %%m! Skipping...
            echo ⚠️ Warning: Skipping %%m due to installation failure.
        ) else (
            echo ✅ Successfully installed %%m!
        )
    )
)

:: Clean up the hidden file after processing
del "%temp_file%" >nul 2>&1

:: Final clear and output
cls
echo 📦 Checking dependencies...
echo 🔍 Updating pip...
echo 🔄 Installing/Verifying Modules:
echo.
echo [████████████████████] 100%% Complete!
echo.

if !all_installed! == true (
    echo ✅ All dependencies are already installed!
) else (
    echo ✅ Dependencies updated successfully, with some modules skipped.
)

pause
