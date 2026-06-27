# Changelog

All notable changes to SkyCanvas will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned for v0.1
- HDMI output to secondary displays
- 9,110 stars from Yale Bright Star Catalog
- Constellation labels and boundaries
- Zoom and pan controls
- Performance optimizations

### Planned for v0.2
- Chromecast support
- Enhanced constellation artwork
- More accurate planet rendering
- Satellite tracking (ISS, Hubble)

## [0.1.0-alpha] - 2026-06-25

### Added
- Initial project setup
- Python astronomy engine using Skyfield
- Real-time sky calculations (stars, planets, moon, sun)
- 15 brightest stars with accurate positions
- Planet position calculations (Mercury, Venus, Mars, Jupiter, Saturn)
- Moon phase calculation
- Flutter Windows desktop app
- Custom star renderer with colors and glow effects
- Stereographic projection (fisheye view)
- Date/time picker controls
- Manual location input
- Dark mode UI
- Object list showing visible celestial bodies
- Basic documentation (README, PRD, ROADMAP)
- MIT License
- Privacy Policy (zero data collection)
- Terms of Service
- Contributing guidelines

### Technical Details
- Flutter 3.0+ support
- Python 3.9+ support
- Skyfield 1.54 for astronomy calculations
- NASA JPL DE421 ephemeris data
- Platform: Windows (initial target)

### Known Issues
- No HDMI output yet
- Limited star catalog (15 stars only)
- No constellation labels
- No zoom/pan functionality
- UTC time only (no timezone conversion)
- No Chromecast support

### Performance
- Startup time: ~5 seconds
- Sky calculation: ~2 seconds
- Rendering: 60fps target

## Versioning Strategy

- **0.1.x** - Alpha releases (Windows desktop only)
- **0.2.x** - Alpha releases (+ Chromecast support)
- **0.3.x** - Beta releases (+ Mobile remote control)
- **0.4.x** - Beta releases (+ macOS, iOS)
- **1.0.0** - First stable public release

## Release Schedule

- v0.1.0-alpha: Week 6 (Target: August 2026)
- v0.2.0-alpha: Week 9
- v0.3.0-beta: Week 13
- v0.4.0-beta: Week 17
- v1.0.0: Week 20 (Target: November 2026)

---

**Note**: This is an early-stage project. Features and timeline may change based on feedback and development progress.
