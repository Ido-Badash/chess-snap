@echo off
echo Setting up ChessSnap API Server...
echo.

:: Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo Error: Python is not installed or not in PATH
    echo Please install Python 3.8+ from https://python.org
    pause
    exit /b 1
)

:: Check if pip is available
pip --version >nul 2>&1
if errorlevel 1 (
    echo Error: pip is not available
    echo Please ensure pip is installed with Python
    pause
    exit /b 1
)

echo Python is available, installing dependencies...
echo.

:: Install requirements
pip install -r requirements.txt

if errorlevel 1 (
    echo.
    echo Error: Failed to install dependencies
    echo Please check the error messages above
    pause
    exit /b 1
)

echo.
echo Setup complete!
echo.
echo To start the server, run:
echo   python app.py
echo.
echo The server will be available at: http://localhost:5000
pause
