#!/bin/bash
echo "========================================"
echo "ChessSnap Server Setup - Virtual Environment (Unix)"
echo "========================================"
echo

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    if ! command -v python &> /dev/null; then
        echo "Error: Python is not installed or not in PATH"
        echo "Please install Python 3.9-3.10"
        exit 1
    fi
    PYTHON_CMD="python"
    PIP_CMD="pip"
else
    PYTHON_CMD="python3"
    PIP_CMD="pip3"
fi

echo "Using Python: $PYTHON_CMD"
$PYTHON_CMD --version

echo
echo "Creating virtual environment..."

# Remove existing venv if it exists
if [ -d "venv" ]; then
    echo "Removing existing virtual environment..."
    rm -rf venv
fi

# Create new virtual environment
$PYTHON_CMD -m venv venv
if [ $? -ne 0 ]; then
    echo "Error: Failed to create virtual environment"
    echo "Make sure you have python3-venv installed:"
    echo "  Ubuntu/Debian: sudo apt install python3-venv"
    echo "  macOS: Should be included with Python 3"
    exit 1
fi

echo "Virtual environment created successfully!"
echo

echo "Activating virtual environment..."
source venv/bin/activate

echo
echo "Upgrading pip..."
$PIP_CMD install --upgrade pip

echo
echo "Installing Python packages from requirements.txt..."
echo "This may take several minutes..."
echo

# Install packages
$PIP_CMD install -r requirements.txt

if [ $? -ne 0 ]; then
    echo
    echo "Error: Failed to install some dependencies"
    echo "Check the error messages above"
    exit 1
fi

echo
echo "========================================"
echo "Setup Complete!"
echo "========================================"
echo
echo "Virtual environment is ready at: $(pwd)/venv"
echo
echo "To activate the environment manually:"
echo "  source venv/bin/activate"
echo
echo "To start the server:"
echo "  ./start_server_venv.sh"
echo
echo "To deactivate when done:"
echo "  deactivate"
echo
