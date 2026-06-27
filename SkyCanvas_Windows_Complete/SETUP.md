# SkyCanvas Setup Guide

## Step 1: Install Flutter

Since Flutter is not installed yet, here's how to install it:

### Option A: Using Scoop (Recommended - You already have Scoop)

```bash
scoop bucket add extras
scoop install flutter
```

### Option B: Manual Installation

1. Download Flutter SDK: https://docs.flutter.dev/get-started/install/windows
2. Extract to `C:\src\flutter`
3. Add to PATH: `C:\src\flutter\bin`
4. Restart terminal

### Verify Installation

```bash
flutter doctor
```

## Step 2: Install Visual Studio Build Tools

Flutter Windows apps need C++ build tools:

### Using Scoop

```bash
scoop install vcredist2022
```

### Or download manually

Download "Build Tools for Visual Studio 2022":
https://visualstudio.microsoft.com/downloads/

Select "Desktop development with C++"

## Step 3: Enable Windows Desktop Support

```bash
flutter config --enable-windows-desktop
```

## Step 4: Install Project Dependencies

```bash
cd "c:\Users\ssivakumar\Sky"

# Python dependencies (already done)
pip install -r python/requirements.txt

# Flutter dependencies (after Flutter is installed)
flutter pub get
```

## Step 5: Run the App

```bash
flutter run -d windows
```

## Current Status

✅ Python astronomy engine - **WORKING**
   - Tested with Delhi coordinates (28.6139, 77.2090)
   - Successfully calculates stars, planets, moon, sun
   - Ephemeris data downloaded (de421.bsp)

⏳ Flutter app - **Waiting for Flutter installation**

## What's Built So Far

1. **Python Astronomy Engine** (`python/sky_engine.py`)
   - Real-time sky calculations
   - Star positions (15 brightest stars)
   - Planet positions (Mercury, Venus, Mars, Jupiter, Saturn)
   - Moon phase calculation
   - Sun position
   - Outputs JSON for easy Flutter integration

2. **Test Results** (2026-06-25 20:30 UTC, Delhi):
   - Sun: Below horizon (nighttime)
   - Moon: 15.4% illuminated (waxing crescent)
   - Saturn visible at 14.7° altitude
   - 4 bright stars visible: Arcturus, Vega, Deneb, Antares

## Next Steps

1. **You do**: Install Flutter using Scoop (`scoop install flutter`)
2. **I'll do**: Create Flutter Windows app with star rendering
3. **We'll do**: Test with your projector

---

**When you've installed Flutter, type "Flutter installed" and I'll continue building the UI!**
