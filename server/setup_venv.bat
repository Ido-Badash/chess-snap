@echo off
echo ========================================
echo ChessSnap Server Setup - Virtual Environment
echo ========================================
echo.

:: Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo Error: Python is not installed or not in PATH
    echo Please install Python 3.9-3.10 from https://python.org
    echo Note: ChessCoG requires Python 3.9-3.10, not 3.11+
    pause
    exit /b 1
)

:: Display Python version
echo Checking Python version...
python --version

:: Check if we have the right Python version (3.9 or 3.10)
python -c "import sys; exit(0 if sys.version_info >= (3,9) and sys.version_info < (3,11) else 1)" 2>nul
if errorlevel 1 (
    echo.
    echo Warning: ChessCoG requires Python 3.9 or 3.10
    echo Current version might not be compatible
    echo Continue anyway? [Y/N]
    set /p continue=
    if /i not "%continue%"=="Y" exit /b 1
)

echo.
echo Creating virtual environment...

:: Remove existing venv if it exists
if exist "venv" (
    echo Removing existing virtual environment...
    rmdir /s /q venv
)

:: Create new virtual environment
python -m venv venv
if errorlevel 1 (
    echo Error: Failed to create virtual environment
    echo Make sure you have the venv module installed
    pause
    exit /b 1
)

echo Virtual environment created successfully!
echo.

echo Activating virtual environment...
call venv\Scripts\activate.bat

echo.
echo Upgrading pip...
python -m pip install --upgrade pip

echo.
echo Installing Python packages from requirements.txt...
echo This may take several minutes...
echo.

:: Install packages with verbose output
pip install -r requirements.txt --verbose

if errorlevel 1 (
    echo.
    echo Error: Failed to install some dependencies
    echo Check the error messages above
    echo.
    echo Common issues:
    echo - PyTorch installation can be slow, make sure you have stable internet
    echo - Some packages require Visual Studio Build Tools on Windows
    echo - ChessCoG models will be downloaded on first use
    pause
    exit /b 1
)

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Virtual environment is ready at: %cd%\venv
echo.
echo To activate the environment manually:
echo   venv\Scripts\activate.bat
echo.
echo To start the server:
echo   start_server_venv.bat
echo.
echo To deactivate when done:
echo   deactivate
echo.
pause
