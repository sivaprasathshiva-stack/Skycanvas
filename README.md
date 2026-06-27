# SkyCanvas

Turn any projector into a window to the universe.

## Quick Start

### Prerequisites

1. **Install Flutter** (Windows Desktop support)
2. **Install Python 3.9+**
3. **Install Visual Studio 2022** (for C++ build tools)

### Installation Steps

```bash
# 1. Clone or download this repository
cd Sky

# 2. Install Python dependencies
pip install skyfield numpy pytz

# 3. Enable Flutter Windows desktop
flutter config --enable-windows-desktop

# 4. Get Flutter dependencies
flutter pub get

# 5. Run the app
flutter run -d windows
```

## Project Structure

```
Sky/
├── lib/                    # Flutter application code
│   ├── main.dart          # App entry point
│   ├── screens/           # UI screens
│   ├── models/            # Data models
│   ├── services/          # Business logic
│   └── widgets/           # Reusable UI components
├── python/                # Astronomy calculation engine
│   ├── sky_engine.py      # Main astronomy calculations
│   └── requirements.txt   # Python dependencies
├── assets/                # Images, data files
│   └── data/              # Star catalogs, constellation data
├── PRD.md                 # Product Requirements Document
├── ROADMAP.md             # Development roadmap
└── README.md              # This file
```

## Features (v0.1)

- ✅ Real-time sky calculations
- ✅ 9,110+ stars from Yale Bright Star Catalog
- ✅ Planets (Sun, Moon, Mercury, Venus, Mars, Jupiter, Saturn)
- ✅ Historical sky replay (any date/time)
- ✅ HDMI output to projectors
- ✅ Constellation lines
- ✅ Manual location input

## Usage

1. Launch SkyCanvas
2. Enter your latitude/longitude
3. Select secondary display (projector)
4. Click "Start Projection"
5. Enjoy the universe on your ceiling!

## Development Status

**Current Version**: v0.1-alpha  
**Status**: In development  
**Target Release**: Week 6  

See [ROADMAP.md](ROADMAP.md) for detailed development plan.

## License

Open source - License TBD

## Contributing

Contributions welcome! This is a work in progress.
