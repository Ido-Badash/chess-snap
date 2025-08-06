#!/bin/bash
echo "========================================"
echo "Starting ChessSnap API Server (Virtual Environment)"
echo "========================================"
echo

# Check if virtual environment exists
if [ ! -f "venv/bin/activate" ]; then
    echo "Error: Virtual environment not found!"
    echo "Please run setup_venv.sh first to create the environment"
    echo
    exit 1
fi

# Change to script directory
cd "$(dirname "$0")"

echo "Activating virtual environment..."
source venv/bin/activate

echo
echo "Virtual environment activated!"
echo "Python location: $(which python)"
echo

echo "Starting ChessSnap API Server..."
echo "Server will be available at: http://localhost:5000"
echo "API endpoint: http://localhost:5000/get_fen"
echo
echo "Press Ctrl+C to stop the server"
echo "========================================"
echo

# Start the Flask server
python app.py

echo
echo "Server stopped."
echo "Deactivating virtual environment..."
deactivate
