import os
import sys

# Ensure we can import from roop when running from app dir
sys.path.insert(0, '.')

from roop.utilities import conditional_download, resolve_relative_path

def main():
    print("Downloading required models...")

    # Main models directory (../models relative to app)
    models_dir = resolve_relative_path('../models')
    os.makedirs(models_dir, exist_ok=True)

    main_models = [
        'https://huggingface.co/countfloyd/deepfake/resolve/main/inswapper_128.onnx',
        'https://huggingface.co/countfloyd/deepfake/resolve/main/GFPGANv1.4.onnx',
        'https://huggingface.co/countfloyd/deepfake/resolve/main/GPEN-BFR-512.onnx',
        'https://huggingface.co/countfloyd/deepfake/resolve/main/restoreformer_plus_plus.onnx',
        'https://huggingface.co/countfloyd/deepfake/resolve/main/xseg.onnx',
        'https://github.com/csxmli2016/DMDNet/releases/download/v1/DMDNet.pth',
    ]
    conditional_download(models_dir, main_models)
    print("Main models downloaded.")

    # CLIP
    clip_dir = resolve_relative_path('../models/CLIP')
    conditional_download(clip_dir, [
        'https://huggingface.co/countfloyd/deepfake/resolve/main/rd64-uni-refined.pth',
    ])
    print("CLIP model downloaded.")

    # CodeFormer
    codeformer_dir = resolve_relative_path('../models/CodeFormer')
    conditional_download(codeformer_dir, [
        'https://huggingface.co/countfloyd/deepfake/resolve/main/CodeFormerv0.1.onnx',
    ])
    print("CodeFormer model downloaded.")

    # Frame models
    frame_dir = resolve_relative_path('../models/Frame')
    frame_models = [
        'https://huggingface.co/countfloyd/deepfake/resolve/main/deoldify_artistic.onnx',
        'https://huggingface.co/countfloyd/deepfake/resolve/main/deoldify_stable.onnx',
        'https://huggingface.co/countfloyd/deepfake/resolve/main/isnet-general-use.onnx',
        'https://huggingface.co/countfloyd/deepfake/resolve/main/real_esrgan_x4.onnx',
        'https://huggingface.co/countfloyd/deepfake/resolve/main/real_esrgan_x2.onnx',
        'https://huggingface.co/countfloyd/deepfake/resolve/main/lsdir_x4.onnx',
    ]
    conditional_download(frame_dir, frame_models)
    print("Frame models downloaded.")

    print("\nAll models downloaded successfully!")

if __name__ == "__main__":
    main()
