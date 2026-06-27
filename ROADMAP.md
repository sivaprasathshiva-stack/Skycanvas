# SkyCanvas Development Roadmap

## Overview

**Vision**: Turn any projector into a window to the universe  
**Strategy**: Desktop-first, free and open-source, protocol-based connectivity  
**Timeline**: 15-20 weeks to v1.0  

---

## Release Strategy

| Release | Platform | Timeline | Key Features | User Base |
|---------|----------|----------|--------------|-----------|
| **v0.1 (Alpha)** | Windows Desktop | Week 6 | HDMI output, basic sky | Early testers |
| **v0.2 (Alpha)** | Windows Desktop | Week 9 | Chromecast support | Wireless users |
| **v0.3 (Beta)** | Windows + Android | Week 13 | Mobile remote control | Mobile users |
| **v0.4 (Beta)** | Multi-platform | Week 17 | macOS + AirPlay | Mac users |
| **v1.0 (Stable)** | All platforms | Week 20 | Polish + optimization | General public |

---

# Release 0.1 - Foundation (Weeks 1-6)

**Theme**: Prove the concept  
**Platform**: Windows Desktop only  
**Distribution**: GitHub releases  
**Target Users**: 10-20 early testers  

## Core Features

### ✅ Astronomy Engine
- [x] Skyfield integration
- [x] Star position calculations (alt/az coordinates)
- [x] Date/time conversion (local to UTC)
- [x] Location-based calculations (latitude/longitude)
- [x] Yale Bright Star Catalog (9,110 stars)
- [x] Planet position calculations (Sun, Moon, Mercury, Venus, Mars, Jupiter, Saturn)
- [x] Real-time sky updates

### ✅ Rendering Engine
- [x] Black canvas with white star dots
- [x] Star brightness (magnitude-based sizing)
- [x] Star colors (spectral types: red, white, blue)
- [x] 60fps smooth rendering
- [x] Stereographic projection (fisheye view)
- [x] Anti-aliasing for smooth stars

### ✅ Display Output
- [x] Secondary display detection
- [x] HDMI output (fullscreen mode)
- [x] Multi-monitor support
- [x] Resolution adaptation (1080p, 4K)
- [x] Aspect ratio handling (16:9, 4:3, ultrawide)

### ✅ User Interface
- [x] Main control window
- [x] Date picker (historical dates)
- [x] Time picker (hour/minute)
- [x] Location input (latitude/longitude)
- [x] Display selector dropdown
- [x] "Start Projection" button
- [x] Simple settings panel

### ✅ Essential Controls
- [x] Manual time progression (play/pause)
- [x] Time speed control (1x, 10x, 100x, 1000x)
- [x] Reset to current time
- [x] Toggle constellation lines

## Technical Milestones

- [ ] Flutter Windows app structure
- [ ] Python astronomy backend (bundled)
- [ ] Star database (SQLite)
- [ ] OpenGL custom painter for stars
- [ ] HDMI projection working
- [ ] Tested with 3+ projector brands

## Success Criteria

- ✅ App launches in <5 seconds
- ✅ Projector displays accurate sky within 30 seconds
- ✅ Stars visible and recognizable
- ✅ No crashes during 1-hour session
- ✅ 5 testers successfully project to their projectors

## Known Limitations

- Windows only
- Manual location entry (no GPS)
- No constellation labels (lines only)
- No deep space objects
- No mobile support
- HDMI cable required
- Basic UI (functional, not beautiful)

---

# Release 0.2 - Wireless Freedom (Weeks 7-9)

**Theme**: Cut the cables  
**Platform**: Windows Desktop  
**Distribution**: GitHub releases  
**Target Users**: 50-100 users  

## New Features

### ✅ Chromecast Support
- [x] Google Cast SDK integration
- [x] Network device discovery (mDNS)
- [x] Cast device selector UI
- [x] Video stream encoding (H.264)
- [x] Cast connection management
- [x] Reconnection on drop
- [x] Quality adaptation (based on network)

### ✅ Enhanced Rendering
- [x] Constellation labels (88 official constellations)
- [x] Constellation boundaries
- [x] Toggle labels on/off
- [x] Greek letters for stars (Alpha, Beta, etc.)
- [x] Star names (100 brightest stars)

### ✅ Improved UI
- [x] Connection status indicator
- [x] "Available Devices" list
- [x] One-tap casting
- [x] Network troubleshooting tips
- [x] Device nicknames

### ✅ Performance
- [x] 30fps minimum on Chromecast
- [x] Latency <500ms
- [x] Smooth time progression while casting
- [x] Buffer management

## Technical Milestones

- [ ] Google Cast SDK working
- [ ] Real-time video encoding pipeline
- [ ] Network discovery reliable
- [ ] Tested with Chromecast Gen 2, Gen 3, Ultra
- [ ] Tested with 5+ different routers

## Success Criteria

- ✅ 90% successful cast connections on first try
- ✅ <30 seconds to start casting
- ✅ Smooth playback for 2+ hours
- ✅ Works on 3+ different network setups
- ✅ 20 users successfully cast wirelessly

## Known Limitations

- Requires same WiFi network
- Some latency (300-500ms)
- Lower quality than HDMI
- No AirPlay support yet
- Still Windows only

---

# Release 0.3 - Mobile Control (Weeks 10-13)

**Theme**: Your phone is the remote  
**Platform**: Windows Desktop + Android Mobile  
**Distribution**: GitHub + APK  
**Target Users**: 200-500 users  

## New Features

### ✅ Android Remote App
- [x] Lightweight Flutter Android app
- [x] Auto-discovers desktop app (Bonjour/mDNS)
- [x] WebSocket communication
- [x] Real-time sync with desktop
- [x] Works on same WiFi network

### ✅ Remote Control Features
- [x] Date/time picker (mobile-optimized)
- [x] Location picker (with map)
- [x] Play/pause time
- [x] Speed controls (slider)
- [x] Zoom in/out (pinch gesture)
- [x] Pan sky (swipe gesture)
- [x] Constellation toggle
- [x] Quick presets ("Show Jupiter", "Current time", "Sunrise")

### ✅ Enhanced Desktop Features
- [x] Zoom controls (mouse wheel)
- [x] Pan controls (click and drag)
- [x] Field of view adjustment (30°-120°)
- [x] North/South/East/West orientation shortcuts
- [x] Search feature ("Find Mars")

### ✅ Planet Features
- [x] Planet labels
- [x] Planet info cards (distance, magnitude, constellation)
- [x] Highlight on tap
- [x] Planet trails (orbital paths)

## Technical Milestones

- [ ] Android app (basic UI)
- [ ] Network discovery between phone and desktop
- [ ] WebSocket server on desktop
- [ ] Command protocol (JSON-based)
- [ ] Gesture handling
- [ ] Tested on 5+ Android devices

## Success Criteria

- ✅ Phone discovers desktop in <10 seconds
- ✅ Commands execute in <200ms
- ✅ No disconnections during 1-hour use
- ✅ Works on Android 8.0+
- ✅ 50 users successfully use mobile remote

## Known Limitations

- Android only (no iPhone yet)
- Requires same network
- Desktop must remain running
- No offline mobile use
- Basic mobile UI

---

# Release 0.4 - Apple Ecosystem (Weeks 14-17)

**Theme**: Premium platforms  
**Platform**: Windows + macOS Desktop, Android + iOS Mobile  
**Distribution**: GitHub + APK + TestFlight  
**Target Users**: 1,000-2,000 users  

## New Features

### ✅ macOS Desktop App
- [x] Native macOS build
- [x] Menu bar integration
- [x] macOS native file picker
- [x] Optimized for Retina displays
- [x] Apple Silicon (M1/M2/M3) optimization

### ✅ AirPlay Support
- [x] AirPlay 2 integration
- [x] Device discovery
- [x] High-quality streaming
- [x] Audio support (optional ambient sounds)
- [x] Works with Apple TV

### ✅ iPhone Remote App
- [x] iOS Flutter app
- [x] iOS-native controls
- [x] Touch ID / Face ID (for premium features later)
- [x] Haptic feedback
- [x] Widgets (quick controls)
- [x] Siri shortcuts ("Show tonight's sky")

### ✅ Visual Enhancements
- [x] Milky Way rendering (subtle glow)
- [x] Atmospheric gradient (horizon glow)
- [x] Moon surface details
- [x] Planet phases (Venus, Mercury)
- [x] Better star colors (stellar classification)
- [x] Meteor simulation (random shooting stars)

### ✅ Quality of Life
- [x] Location presets (save favorite locations)
- [x] Time presets (sunset, midnight, sunrise)
- [x] Auto-detect system location (permission-based)
- [x] Recent projections history
- [x] Keyboard shortcuts (space=play/pause, etc.)

## Technical Milestones

- [ ] macOS code signing
- [ ] AirPlay SDK integration
- [ ] iOS app (TestFlight ready)
- [ ] Cross-platform feature parity
- [ ] Tested on macOS 13+, iOS 15+

## Success Criteria

- ✅ Mac users can project via AirPlay
- ✅ iPhone remote works seamlessly
- ✅ Visual quality matches competitor apps
- ✅ <5% crash rate
- ✅ 100+ active Mac users

## Known Limitations

- macOS requires 10.14+
- iOS requires iOS 15+
- AirPlay limited to Apple devices
- No Linux support yet
- No Android TV app yet

---

# Release 1.0 - Public Launch (Weeks 18-20)

**Theme**: Ready for the world  
**Platform**: Windows, macOS, Android, iOS  
**Distribution**: GitHub + Microsoft Store + APK + TestFlight  
**Target Users**: 10,000+ downloads in first month  

## Polish & Optimization

### ✅ Performance
- [x] 60fps on all platforms
- [x] <100MB memory usage
- [x] <5 second startup time
- [x] Smooth transitions
- [x] No frame drops during casting

### ✅ User Experience
- [x] Onboarding tutorial (first-time users)
- [x] Interactive help tooltips
- [x] Error messages (user-friendly)
- [x] Connection troubleshooting wizard
- [x] In-app feedback form

### ✅ Visual Polish
- [x] App icon (all sizes)
- [x] Splash screen
- [x] Loading animations
- [x] Professional UI design
- [x] Dark mode support
- [x] Accessibility (screen readers, high contrast)

### ✅ Content
- [x] 50,000+ stars (Hipparcos catalog)
- [x] All 88 constellations
- [x] Messier objects (110 deep-sky objects)
- [x] Major satellites (ISS, Hubble, Tiangong)
- [x] Solar eclipses (with dates)
- [x] Lunar eclipses (with dates)

### ✅ Documentation
- [x] User guide (PDF + web)
- [x] FAQ page
- [x] Video tutorials (YouTube)
- [x] Troubleshooting guide
- [x] API documentation (for contributors)
- [x] Developer setup guide

### ✅ Community
- [x] GitHub repository (public)
- [x] Issue tracker
- [x] Discord server
- [x] Subreddit
- [x] Contributing guidelines
- [x] Code of conduct

## Technical Milestones

- [ ] Full test coverage (80%+)
- [ ] CI/CD pipeline (automated builds)
- [ ] Crash reporting (Sentry or similar)
- [ ] Analytics (privacy-respecting)
- [ ] Automated installers (Windows MSI, macOS DMG)
- [ ] Linux builds (AppImage, Snap)

## Success Criteria

- ✅ 10,000 downloads in first month
- ✅ 4.5+ star rating (user reviews)
- ✅ <1% crash rate
- ✅ Featured on Product Hunt, Hacker News
- ✅ 5+ YouTube reviews
- ✅ 1,000+ GitHub stars

## Supported Configurations

### Platforms
- ✅ Windows 10/11 (64-bit)
- ✅ macOS 11+ (Intel + Apple Silicon)
- ✅ Android 8.0+
- ✅ iOS 15+

### Connection Methods
- ✅ HDMI (all platforms)
- ✅ Chromecast (Gen 2+)
- ✅ AirPlay 2
- ✅ Google Cast built-in TVs
- ✅ Android TV (sideload)

### Display Resolutions
- ✅ 1080p (1920x1080)
- ✅ 4K (3840x2160)
- ✅ Ultrawide (2560x1080, 3440x1440)
- ✅ 720p (1280x720)

### Tested Projectors
- ✅ Epson Home Cinema series
- ✅ BenQ HT/TH series
- ✅ XGIMI Horizon/MoGo
- ✅ Anker Nebula
- ✅ ViewSonic
- ✅ Budget projectors (WZATCO, EGate, etc.)

---

# Post-1.0 Roadmap (Future Releases)

## Release 1.1 - Education Mode (Month 2-3)

**Target**: Teachers and students

### Features
- [ ] Lesson plans (pre-configured scenarios)
- [ ] Quiz mode (interactive learning)
- [ ] Solar system exploration
- [ ] Planet comparison tool
- [ ] Time-lapse (watch planets move)
- [ ] Ecliptic plane visualization
- [ ] Celestial coordinates overlay
- [ ] Export screenshots (for presentations)

## Release 1.2 - Sleep & Meditation (Month 3-4)

**Target**: Wellness users

### Features
- [ ] Sleep timer (auto-dim and stop)
- [ ] Ambient soundscapes (ocean, rain, space)
- [ ] Breathing exercises (with visual guide)
- [ ] Guided meditation (audio)
- [ ] Circadian mode (warm colors at night)
- [ ] Slow motion (ultra-slow star movement)
- [ ] Fireplace mode (crackling fire on ceiling)

## Release 1.3 - Kids Mode (Month 4-5)

**Target**: Families with children

### Features
- [ ] Animated constellations (characters come alive)
- [ ] Space stories (narrated)
- [ ] Interactive games (find the planet)
- [ ] Coloring mode (colorful cartoon stars)
- [ ] Educational videos (embedded)
- [ ] Parental controls
- [ ] Achievement badges

## Release 1.4 - Advanced Features (Month 5-6)

**Target**: Astronomy enthusiasts

### Features
- [ ] Telescope control (ASCOM/INDI integration)
- [ ] Custom catalogs (import your own)
- [ ] Observation planning (what's visible tonight)
- [ ] Light pollution overlay
- [ ] Satellite predictions (with alerts)
- [ ] Asteroid tracking
- [ ] Comet tracking
- [ ] Variable star monitoring
- [ ] Supernova alerts

## Release 2.0 - Premium Experiences (Month 6-9)

**Strategy**: Add optional paid content (open-source core remains free)

### Premium Features (Optional Purchase)
- [ ] Northern Lights (realistic aurora)
- [ ] Underwater ocean (coral reefs, fish)
- [ ] Rainforest (sounds and visuals)
- [ ] Mars surface (rover POV)
- [ ] Moon landing (Apollo missions)
- [ ] ISS interior tour
- [ ] Black hole journey
- [ ] Nebula fly-through
- [ ] Galaxy zoom (from Milky Way to distant galaxies)

### Monetization
- Core app: Free forever
- Premium packs: $2.99 each
- All premium bundle: $9.99
- Revenue split: 50% to open-source contributors

## Release 2.5 - Hardware (Month 9-12)

**Product**: SkyCanvas Hub (optional hardware)

### Features
- [ ] Plug-and-play HDMI device
- [ ] Auto-discovery by mobile apps
- [ ] Standalone operation (no computer needed)
- [ ] Raspberry Pi 4/5 based
- [ ] Custom 3D-printed case
- [ ] Price: $99
- [ ] Open hardware (DIY instructions available)

## Release 3.0 - AI Assistant (Month 12+)

**Feature**: Free AI using local models

### Features
- [ ] Local LLM (Ollama integration)
- [ ] Voice control (offline)
- [ ] "What is that star?" (image recognition)
- [ ] Natural language ("Show me where Mars was when I was born")
- [ ] Daily sky summaries
- [ ] Personalized recommendations
- [ ] No cloud required
- [ ] Privacy-first

---

# Development Principles

## Technical Principles
1. **Free and open-source** - Core features always free
2. **Privacy-first** - No telemetry without consent
3. **Offline-capable** - Works without internet
4. **Protocol-based** - Never hardcode device brands
5. **Cross-platform** - Same codebase, all platforms
6. **Performance** - 60fps minimum
7. **Accessibility** - Usable by everyone

## Feature Principles
1. **Scientifically accurate** - Real astronomy data
2. **Magical experience** - Wow users in 30 seconds
3. **Simple by default** - Advanced features hidden
4. **No subscription** - One-time purchase for premium only
5. **Community-driven** - Listen to user feedback

## Design Principles
1. **Beautiful minimalism** - Less is more
2. **Dark UI** - Easy on eyes at night
3. **Gesture-friendly** - Touch and mouse optimized
4. **Accessible** - WCAG 2.1 AA compliant
5. **Responsive** - Adapts to any screen size

---

# Success Metrics by Release

| Release | Downloads | Active Users | Retention (30-day) | GitHub Stars |
|---------|-----------|--------------|-------------------|--------------|
| v0.1 | 20 | 10 | 50% | 10 |
| v0.2 | 100 | 50 | 60% | 50 |
| v0.3 | 500 | 200 | 65% | 200 |
| v0.4 | 2,000 | 800 | 70% | 500 |
| v1.0 | 10,000 | 3,000 | 75% | 1,000 |
| v1.5 | 50,000 | 15,000 | 80% | 5,000 |
| v2.0 | 200,000 | 60,000 | 85% | 10,000 |

---

# Risk Management

## Technical Risks

| Risk | Mitigation |
|------|------------|
| Casting reliability issues | Test with 10+ devices, fallback to HDMI |
| Performance on low-end devices | Scalable star count, quality presets |
| Astronomy calculation accuracy | Compare with Stellarium, use NASA data |
| Network discovery failures | Manual IP input option |
| Platform-specific bugs | Beta testing program, staged rollout |

## Market Risks

| Risk | Mitigation |
|------|------------|
| Low projector ownership | Also support TVs, monitors |
| Competitors (Stellarium) | Focus on projection UX, not just astronomy |
| User acquisition | Reddit, YouTube, astronomy communities |
| Sustainability (free product) | Optional premium content, donations |
| Feature creep | Strict MVP scope, roadmap discipline |

---

# Resource Requirements

## Time Investment (Solo Developer)

| Phase | Part-time (15hr/wk) | Full-time (40hr/wk) |
|-------|---------------------|---------------------|
| v0.1 | 6 weeks | 2.5 weeks |
| v0.2 | 3 weeks | 1 week |
| v0.3 | 4 weeks | 1.5 weeks |
| v0.4 | 4 weeks | 1.5 weeks |
| v1.0 | 3 weeks | 1 week |
| **Total to v1.0** | **20 weeks (5 months)** | **7.5 weeks (2 months)** |

## Cost Breakdown (Free Version)

| Item | Cost |
|------|------|
| Development tools | $0 |
| Cloud hosting | $0 |
| APIs | $0 |
| App stores (optional) | $0-118 |
| Testing devices (use existing) | $0 |
| **Total** | **$0-118** |

## With Paid Services (v2.0+)

| Item | Monthly Cost |
|------|--------------|
| Cloud hosting (AWS) | $50-200 |
| AI APIs (OpenAI) | $50-500 |
| CDN (CloudFront) | $20-100 |
| Analytics | $0 (self-hosted) |
| **Total** | **$120-800/month** |

---

# Launch Checklist (v1.0)

## Pre-Launch (Week 18)
- [ ] All features tested on all platforms
- [ ] Zero critical bugs
- [ ] Documentation complete
- [ ] Video tutorial recorded
- [ ] Launch blog post written
- [ ] Social media accounts created
- [ ] GitHub repository polished (README, screenshots)

## Launch Day (Week 19)
- [ ] Post on Product Hunt
- [ ] Post on Hacker News
- [ ] Reddit posts (r/astronomy, r/space, r/projectors)
- [ ] YouTube video uploaded
- [ ] Tweet announcement
- [ ] Email astronomy communities
- [ ] Press release (optional)

## Post-Launch (Week 20+)
- [ ] Monitor crash reports
- [ ] Respond to issues on GitHub
- [ ] Engage with community
- [ ] Collect feedback
- [ ] Plan v1.1 features
- [ ] Write "lessons learned" post

---

# Community Building

## Channels
- **GitHub** - Code, issues, discussions
- **Discord** - Real-time chat, support
- **Reddit** - r/SkyCanvas (create after v0.4)
- **YouTube** - Tutorials, demos
- **Twitter/X** - Updates, announcements
- **Email** - Newsletter (monthly)

## Contribution Areas
- Code (features, bug fixes)
- Design (UI/UX improvements)
- Documentation (guides, translations)
- Testing (bug reports)
- Content (constellation stories, lesson plans)
- Astronomy data (catalogs, ephemerides)

## Incentives
- Contributor recognition (credits page)
- Early access to features
- Exclusive Discord role
- Revenue sharing (if premium features added)

---

# Long-term Vision (3-5 Years)

1. **10 million downloads** worldwide
2. **#1 astronomy projection app** on all platforms
3. **10,000 schools** using educational mode
4. **1,000 open-source contributors**
5. **Hardware product** (SkyCanvas Hub) in homes
6. **Partnerships** with planetariums, museums
7. **Awards** (App of the Year, etc.)
8. **Sustainability** through ethical monetization

---

**Next Step**: Choose your starting point → [PRD.md](PRD.md) | [Begin v0.1 Development](#release-01---foundation-weeks-1-6)
