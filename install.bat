@echo off
echo ========================================
echo SkyCanvas Installation Script
echo ========================================
echo.

echo [1/5] Checking Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python not found. Please install Python 3.9+
    pause
    exit /b 1
)
python --version
echo.

echo [2/5] Installing Python dependencies...
cd python
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo ERROR: Failed to install Python dependencies
    pause
    exit /b 1
)
cd ..
echo Python dependencies installed successfully!
echo.

echo [3/5] Checking Flutter...
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo WARNING: Flutter not found
    echo Please install Flutter: scoop install flutter
    echo Or visit: https://docs.flutter.dev/get-started/install/windows
    pause
    exit /b 1
)
flutter --version
echo.

echo [4/5] Enabling Windows desktop support...
flutter config --enable-windows-desktop
echo.

echo [5/5] Installing Flutter dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Failed to install Flutter dependencies
    pause
    exit /b 1
)
echo.

echo ========================================
echo Installation complete!
echo ========================================
echo.
echo Next steps:
echo 1. Run the app: flutter run -d windows
echo 2. Or build release: flutter build windows --release
echo.
echo For help, see: README.md or SETUP.md
echo.
pause
