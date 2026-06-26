# renvveyult

AI Face Swapper — swap faces in photos and videos quickly, no training required.

Powered by InsightFace + ONNX, with a clean Gradio web interface.

This repository is set up for easy installation via [Pinokio](https://pinokio.computer/).

## Install (Recommended)

1. Install [Pinokio](https://pinokio.computer/)
2. Add this repository: `https://github.com/renvvey/renvveyult`
3. Click **Install**

## Features

- Fast face swapping using InsightFace
- Gradio browser-based UI
- Multi-face support, gender filtering, manual selection
- Advanced masking (manual, XSeg, CLIP)
- Face restoration and upscaling (GFPGAN, CodeFormer, etc.)
- Video and image batch processing
- Virtual camera output
- Optional TensorRT acceleration (Windows + NVIDIA)

## Run Manually (without Pinokio)

```bash
git clone https://github.com/renvvey/renvveyult.git
cd renvveyult

# Create and activate virtual environment
python -m venv venv
venv\Scripts\activate

# Install dependencies
pip install -r app/requirements.txt

# (Important) Install torch for your GPU, for example for NVIDIA CUDA 12.1:
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu121

cd app
python run.py
```

Then open the URL shown in the terminal (usually http://127.0.0.1:7860).

## Credits

This project is based on the excellent work from the roop-unleashed community (originally by C0untFloyd and contributors).  
This repository contains my customized setup and Pinokio integration.

## License

See [LICENSE](LICENSE) file.

---

For issues or questions, open an issue in this repository.
