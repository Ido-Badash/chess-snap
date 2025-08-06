@echo off
echo ========================================
echo Starting ChessSnap API Server (Virtual Environment)
echo ========================================
echo.

:: Check if virtual environment exists
if not exist "venv\Scripts\activate.bat" (
    echo Error: Virtual environment not found!
    echo Please run setup_venv.bat first to create the environment
    echo.
    pause
    exit /b 1
)

:: Change to script directory
cd /d "%~dp0"

echo Activating virtual environment...
call venv\Scripts\activate.bat

echo.
echo Virtual environment activated!
echo Python location: 
where python
echo.

echo Starting ChessSnap API Server...
echo Server will be available at: http://localhost:5000
echo API endpoint: http://localhost:5000/get_fen
echo.
echo Press Ctrl+C to stop the server
echo ========================================
echo.

:: Start the Flask server
python app.py

echo.
echo Server stopped.
echo Deactivating virtual environment...
deactivate
