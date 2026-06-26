# renvveyult

AI Face Swapper — swap faces in photos and videos quickly, no training required.

Powered by InsightFace + ONNX, with a clean Gradio web interface.

This project supports Windows, macOS and Linux.

## Recommended: Install via Pinokio (easiest cross-platform)

1. Install [Pinokio](https://pinokio.computer/) (works on Mac and Windows)
2. Add this repository: `https://github.com/renvvey/renvveyult2210`
3. Click **Install**

The correct torch and onnxruntime for your platform will be installed automatically, and models will be downloaded.

## Manual Installation

### macOS

```bash
git clone https://github.com/renvvey/renvveyult2210.git
cd renvveyult2210

# Go to the app directory
cd app

# Make the script executable
chmod +x runMacOS.sh

# Run it (it will use or help with Python 3.11 via Homebrew and create a venv)
./runMacOS.sh
```

If it complains about Python 3.11, install it first:

```bash
brew install python@3.11
```

After first run, models will be downloaded automatically.

To run again later:

```bash
cd app
source .venv/bin/activate
python run.py
```

**For better performance on Apple Silicon**, after activating venv you can try:

```bash
pip install onnxruntime-silicon
```

Then run with CPU provider:

```bash
python run.py --execution-provider cpu
```

### Windows (Manual)

```powershell
git clone https://github.com/renvvey/renvveyult2210.git
cd renvveyult2210
cd app

python -m venv venv
venv\Scripts\activate

pip install -r requirements.txt
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Models will be downloaded automatically on first run
python run.py
```

If no NVIDIA GPU, use:

```powershell
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
python run.py --execution-provider cpu
```

### Linux

Similar to Windows, use python -m venv and install torch from official index (CPU or CUDA as needed).

## Running the App

The web interface opens in your browser (usually http://127.0.0.1:7860).

You can pass `--execution-provider cpu` if you don't have a supported GPU.

## Features

- Fast face swapping using InsightFace
- Gradio browser-based UI
- Multi-face support, gender filtering, manual selection
- Advanced masking (manual, XSeg, CLIP)
- Face restoration and upscaling (GFPGAN, CodeFormer, etc.)
- Video and image batch processing
- Virtual camera output
- Optional TensorRT acceleration (Windows + NVIDIA)

## For Advanced Users (Manual / Update)

If you want to manage the environment yourself or update:

```powershell
git clone https://github.com/renvvey/renvveyult.git
cd renvveyult
```

Then run `install.bat` again to reinstall or update.

Models are stored in the `models` folder next to `app`. You can delete and re-download them by running the download script again if needed.


Then open the URL shown in the terminal (usually http://127.0.0.1:7860).

## Credits

This project is based on the excellent work from the roop-unleashed community (originally by C0untFloyd and contributors).  
This repository contains my customized setup and Pinokio integration.

## License

See [LICENSE](LICENSE) file.

---

For issues or questions, open an issue in this repository.
