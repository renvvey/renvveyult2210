#!/bin/bash

# renvveyult macOS runner
# Run this from inside the app/ folder:
#   cd app
#   ./runMacOS.sh

set -e

echo "=== renvveyult macOS Setup ==="

# Ensure we're in the app directory
if [ ! -f "run.py" ]; then
    echo "Error: run.py not found. Please cd into the 'app' directory first."
    echo "Example:"
    echo "  cd renvveyult2210/app"
    echo "  ./runMacOS.sh"
    exit 1
fi

VENV_DIR=".venv"

# Try to find a good Python (prefer 3.11 or 3.10)
PYTHON_CMD=""

if command -v python3.11 >/dev/null 2>&1; then
    PYTHON_CMD="python3.11"
elif command -v python3.10 >/dev/null 2>&1; then
    PYTHON_CMD="python3.10"
elif command -v python3 >/dev/null 2>&1; then
    PYTHON_CMD="python3"
else
    echo "Python 3 not found."
    echo "Please install Python 3.10 or 3.11 using Homebrew:"
    echo "  brew install python@3.11"
    exit 1
fi

echo "Using Python: $($PYTHON_CMD --version)"

# Create venv if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    $PYTHON_CMD -m venv $VENV_DIR
fi

# Activate
source "$VENV_DIR/bin/activate"

echo "Installing/updating dependencies..."
pip install --upgrade pip

if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
fi

# Install torch for macOS (Apple Silicon or Intel)
echo "Installing PyTorch for macOS..."
pip install torch torchvision torchaudio

# Optional: better ONNX on Apple Silicon
if [[ $(uname -m) == "arm64" ]]; then
    echo "Installing onnxruntime-silicon for Apple Silicon..."
    pip install onnxruntime-silicon || echo "onnxruntime-silicon install failed, continuing with default..."
fi

# Download models if needed (will skip if already present)
echo "Checking/downloading models..."
python download_models.py || echo "Model download script had issues, continuing..."

echo ""
echo "=== Starting renvveyult ==="
echo "The web UI will open in your browser shortly."
echo ""

python run.py --execution-provider cpu

deactivate
