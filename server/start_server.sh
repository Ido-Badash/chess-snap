#!/bin/bash
echo "========================================"
echo "Starting ChessSnap API Server (Shell)"
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
else
    PYTHON_CMD="python3"
fi

# Change to script directory
cd "$(dirname "$0")"

echo "Starting ChessSnap API Server..."
echo "Server will be available at: http://localhost:5000"
echo "API endpoint: http://localhost:5000/get_fen"
echo
echo "Press Ctrl+C to stop the server"
echo "========================================"
echo

# Start the Flask server
$PYTHON_CMD app.py

echo
echo "Server stopped."
