@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ================================================
echo   renvveyult - Full Standalone Installer
echo   (No Python required)
echo ================================================
echo.
echo This will download and set up everything needed:
echo - Miniconda (portable Python)
echo - All dependencies
echo - AI models (several GB)
echo.
echo WARNING: This requires ~10-15 GB free space and a good internet connection.
echo It can take 15-40 minutes depending on your PC.
echo.
pause

set INSTALL_DIR=%~dp0installer_files
set CONDA_ROOT=%INSTALL_DIR%\conda
set ENV_DIR=%INSTALL_DIR%\env
set MINICONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe
set FFMPEG_URL=https://github.com/GyanD/codexffmpeg/releases/download/2023-06-21-git-1bcb8a7338/ffmpeg-2023-06-21-git-1bcb8a7338-essentials_build.zip
set INSIGHTFACE_WHEEL_URL=https://github.com/renvvey/renvveyult/releases/download/3.6.6/insightface-0.7.3-cp310-cp310-win_amd64.whl

:: Check if already installed
if exist "%ENV_DIR%\python.exe" (
    echo Environment already exists.
    choice /C YN /M "Reinstall everything? (Y/N)"
    if errorlevel 2 goto :launch
    echo Removing old environment...
    rmdir /s /q "%INSTALL_DIR%"
)

:: Download and install Miniconda (portable)
if not exist "%CONDA_ROOT%\_conda.exe" (
    echo [1/5] Downloading Miniconda...
    if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
    curl -L -o "%INSTALL_DIR%\miniconda.exe" "%MINICONDA_URL%" || (
        echo Failed to download Miniconda.
        echo Please download manually: %MINICONDA_URL%
        pause
        exit /b 1
    )

    echo Installing Miniconda (portable)...
    start /wait "" "%INSTALL_DIR%\miniconda.exe" /InstallationType=JustMe /NoShortcuts=1 /AddToPath=0 /RegisterPython=0 /NoRegistry=1 /S /D=%CONDA_ROOT%
    if not exist "%CONDA_ROOT%\_conda.exe" (
        echo Miniconda installation failed.
        pause
        exit /b 1
    )
    del "%INSTALL_DIR%\miniconda.exe" 2>nul
)

:: Create conda environment with Python 3.10
if not exist "%ENV_DIR%\python.exe" (
    echo [2/5] Creating Python environment...
    call "%CONDA_ROOT%\condabin\conda.bat" create --no-shortcuts -y -k --prefix "%ENV_DIR%" python=3.10
    if not exist "%ENV_DIR%\python.exe" (
        echo Failed to create environment.
        pause
        exit /b 1
    )
)

:: Activate env
call "%CONDA_ROOT%\condabin\conda.bat" activate "%ENV_DIR%"

:: Install insightface wheel (often more reliable on Windows)
if not exist "%INSTALL_DIR%\insightface.whl" (
    echo [3/5] Downloading insightface package...
    curl -L -o "%INSTALL_DIR%\insightface.whl" "%INSIGHTFACE_WHEEL_URL%" || (
        echo Could not download insightface wheel. Will try pip later.
    )
)

if exist "%INSTALL_DIR%\insightface.whl" (
    echo Installing insightface from wheel...
    pip install "%INSTALL_DIR%\insightface.whl" --no-deps || echo Wheel install had issues, continuing...
) else (
    echo Installing insightface via pip...
    pip install insightface==0.7.3
)

:: Install main requirements
echo [4/5] Installing dependencies...
pip install -r "%~dp0app\requirements.txt"

:: Install PyTorch (CUDA preferred)
echo Installing PyTorch (this is the biggest part)...
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 || (
    echo CUDA install failed, trying CPU version...
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
)

:: Download models
echo [5/5] Downloading AI models (large files)...
pushd "%~dp0app"
python download_models.py
popd

:: Install FFmpeg if needed (simple)
where ffmpeg >nul 2>nul || (
    echo Downloading FFmpeg...
    if not exist "%INSTALL_DIR%\ffmpeg.zip" (
        curl -L -o "%INSTALL_DIR%\ffmpeg.zip" "%FFMPEG_URL%"
    )
    powershell -command "Expand-Archive -Force '%INSTALL_DIR%\ffmpeg.zip' '%INSTALL_DIR%\'"
    :: Simple rename if needed
)

echo.
echo ================================================
echo   Installation complete!
echo.
echo You can now run the program with run.bat
echo A desktop shortcut will be created...
echo ================================================

:: Create desktop shortcut
set SCRIPT="%TEMP%\create_shortcut.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") > %SCRIPT%
echo sLinkFile = oWS.SpecialFolders("Desktop") ^& "\renvveyult.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%~dp0run.bat" >> %SCRIPT%
echo oLink.WorkingDirectory = "%~dp0" >> %SCRIPT%
echo oLink.IconLocation = "%~dp0icon.png" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del %SCRIPT%

echo.
echo Done! You can launch "renvveyult" from your Desktop.
pause
goto :eof

:launch
echo Launching...
call "%~dp0run.bat"
goto :eof
