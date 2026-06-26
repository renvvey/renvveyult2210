@echo off
chcp 65001 >nul

set INSTALL_DIR=%~dp0installer_files
set CONDA_ROOT=%INSTALL_DIR%\conda
set ENV_DIR=%INSTALL_DIR%\env

if not exist "%ENV_DIR%\python.exe" (
    echo Environment not found.
    echo Please run install.bat first.
    pause
    exit /b 1
)

echo Activating environment...
call "%CONDA_ROOT%\condabin\conda.bat" activate "%ENV_DIR%"

cd /d "%~dp0app"
echo Starting renvveyult...
python run.py

echo.
echo Application closed.
pause
