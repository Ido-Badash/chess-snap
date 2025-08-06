@echo off
echo ========================================
echo Testing ChessSnap Environment
echo ========================================
echo.

:: Check if virtual environment exists
if not exist "venv\Scripts\activate.bat" (
    echo Error: Virtual environment not found!
    echo Please run setup_venv.bat first
    pause
    exit /b 1
)

:: Activate virtual environment
call venv\Scripts\activate.bat

echo Testing Python and package imports...
echo.

python -c "
import sys
print(f'Python version: {sys.version}')
print()

# Test core dependencies
try:
    import flask
    print('✓ Flask:', flask.__version__)
except ImportError as e:
    print('✗ Flask: MISSING')

try:
    import numpy as np
    print('✓ NumPy:', np.__version__)
except ImportError:
    print('✗ NumPy: MISSING')

try:
    import cv2
    print('✓ OpenCV:', cv2.__version__)
except ImportError:
    print('✗ OpenCV: MISSING')

try:
    import torch
    print('✓ PyTorch:', torch.__version__)
except ImportError:
    print('✗ PyTorch: MISSING')

try:
    import PIL
    print('✓ Pillow:', PIL.__version__)
except ImportError:
    print('✗ Pillow: MISSING')

try:
    import chess
    print('✓ Chess:', chess.__version__)
except ImportError:
    print('✗ Chess: MISSING')

print()

# Test ChessSnap specific imports
try:
    from chess_positions import RecognitionPipeline
    print('✓ ChessSnap RecognitionPipeline: OK')
except ImportError as e:
    print('✗ ChessSnap RecognitionPipeline: MISSING')
    print(f'   Error: {e}')

try:
    import inference_sdk
    print('✓ Inference SDK: OK')
except ImportError:
    print('✗ Inference SDK: MISSING')

print()
print('Environment test complete!')
"

echo.
echo Deactivating virtual environment...
deactivate
echo.
pause
