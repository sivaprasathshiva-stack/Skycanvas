# 📱 SkyCanvas Mobile App - Product Requirements Document

**Project**: SkyCanvas Mobile Planetarium  
**Platform**: Android & iOS  
**Version**: 1.0  
**Date**: June 25, 2026  
**Status**: 🚀 READY TO START

---

## 🎯 Vision

A **standalone mobile planetarium app** that brings the night sky to your fingertips. Unlike the remote control app, this is a full-featured, self-contained astronomy app that works independently.

**Target Users**:
- Stargazers who want to identify stars on the go
- Students learning astronomy
- Campers and hikers exploring the night sky
- Astronomy enthusiasts without a desktop setup
- Parents teaching kids about space

---

## ✨ Core Features (Must Have)

### 1. Real-Time Star Map 🌟
**Description**: Live, accurate star map showing current sky position

**Features**:
- Display 9,110 stars from Yale Bright Star Catalog
- Show planets (Mercury, Venus, Mars, Jupiter, Saturn)
- Moon with current phase
- Sun position (with warning not to look at sun)
- Real-time updates based on device GPS
- Automatic compass orientation (phone points at sky)
- Touch to identify objects
- Zoom and pan gestures
- Magnitude filter (show only bright stars)

**Technical**:
- Use device GPS for location
- Use accelerometer + magnetometer for orientation
- Integrate astronomy calculation engine
- Custom star rendering with glow effects
- Smooth 60 FPS animations

---

### 2. Augmented Reality Mode 📸
**Description**: Point phone at sky, see real-time labels

**Features**:
- Camera pass-through with star overlay
- Real-time object identification
- Tap to learn more about any star/planet
- Screenshot capability
- Night mode (red tint to preserve night vision)
- Auto-calibration with compass + gyroscope

**Technical**:
- ARCore (Android) / ARKit (iOS)
- Camera permissions
- Sensor fusion (GPS + compass + gyroscope)
- Smooth overlay rendering
- Battery optimization

---

### 3. Time Travel ⏰
**Description**: View sky from any date/time

**Features**:
- Date picker (1900-2100)
- Time slider with play/pause
- Speed controls (1x, 10x, 100x, 1000x)
- Quick presets: Sunrise, Noon, Sunset, Midnight
- Historical events: "Show sky during Apollo 11 landing"
- Future events: "Show Mars opposition on [date]"

**Technical**:
- Precise astronomical calculations
- Efficient date/time handling
- Animation performance optimization

---

### 4. Object Search & Information 🔍
**Description**: Find and learn about celestial objects

**Features**:
- Search bar: "Find Jupiter", "Find Orion", "Find Vega"
- Auto-complete suggestions
- Object info cards:
  - Name (common + scientific)
  - Current position (azimuth, altitude)
  - Rise/set times
  - Distance from Earth
  - Brightness (magnitude)
  - Constellation membership
  - Fun facts
- Bookmark favorites
- "What's visible tonight?" list
- "Best viewing times" calculator

**Technical**:
- Fast search indexing
- Rich object database
- Rise/set calculations
- Offline data storage

---

### 5. Constellation View 🦂
**Description**: Show constellation patterns and mythology

**Features**:
- Toggle constellation lines
- Constellation labels
- 88 IAU constellations (start with 20 major ones)
- Tap constellation for info:
  - Greek/Roman mythology story
  - Stars in constellation
  - How to find it
  - Best viewing season
- Constellation artwork (optional overlay)
- Filter by season/hemisphere

**Technical**:
- Constellation line data (RA/Dec coordinates)
- Story database
- Seasonal visibility calculations

---

### 6. Location Management 📍
**Description**: Multiple location support

**Features**:
- Auto-detect via GPS
- Manual input (latitude/longitude)
- City search: "New York", "Tokyo", "Sydney"
- Save favorite locations
- Show timezone
- Display horizon line
- Elevation factor (for mountain viewing)

**Technical**:
- GPS permissions
- Geocoding API (city → coordinates)
- Location database
- Timezone calculations

---

### 7. Night Mode 🌙
**Description**: Preserve night vision

**Features**:
- Red light mode (entire UI)
- Adjustable brightness
- Auto-enable at sunset
- Quick toggle button
- Screen dimming controls

**Technical**:
- Red color filter overlay
- Brightness control API
- Sunset/sunrise calculations

---

### 8. Events Calendar 📅
**Description**: Upcoming astronomical events

**Features**:
- Meteor showers (Perseids, Geminids, etc.)
- Eclipses (solar, lunar)
- Planet conjunctions
- Full moons
- ISS visible passes (if location available)
- Notifications for selected events

**Technical**:
- Event database
- Notification scheduling
- Calendar integration
- ISS TLE data (optional)

---

### 9. Education Mode 🎓
**Description**: Learn while you explore

**Features**:
- Beginner mode (simplified UI)
- Tutorial overlay: "This is Polaris, the North Star"
- Quizzes: "Can you find the Big Dipper?"
- Achievement badges
- "Star of the day" feature
- Fun facts on splash screen

**Technical**:
- Tutorial system
- Quiz engine
- Achievement tracking
- Local storage for progress

---

### 10. Social Sharing 📲
**Description**: Share discoveries with friends

**Features**:
- Screenshot current sky view
- Add labels to screenshots
- Share to social media
- "Look what I found!" templates
- QR code to share exact view (date/time/location)

**Technical**:
- Screenshot API
- Image annotation
- Share intent/sheet
- QR code generation

---

## 🌟 Advanced Features (Nice to Have)

### 11. 3D Planet View 🪐
- Tap planet → see 3D model
- Rotate to view from any angle
- Show moons (Jupiter's Galilean moons, Saturn's Titan)
- Planet info (size, mass, distance, fun facts)

### 12. Deep Space Objects 🌌
- Nebulae (Orion Nebula, Eagle Nebula)
- Galaxies (Andromeda, Whirlpool)
- Star clusters (Pleiades, Beehive)
- Filter by object type
- "Messier catalog" tour

### 13. Telescope Control 🔭
- Connect to smart telescopes via Bluetooth
- Slew telescope to selected object
- Track object automatically
- Camera integration for astrophotography

### 14. Multi-Language Support 🌍
- English, Spanish, French, German, Japanese, Chinese
- Localized constellation names
- Cultural astronomy stories (Greek, Chinese, Aboriginal)

### 15. Offline Mode ✈️
- Download star catalog for offline use
- Cached object info
- Works without internet (except GPS)

---

## 🎨 UI/UX Design

### Color Scheme
- **Dark theme**: Black (#000000) background
- **Stars**: White to blue gradient
- **Planets**: Accurate colors (Mars = red, Jupiter = beige)
- **UI elements**: Deep blue (#1E3A8A) with white text
- **Night mode**: Red tint (#FF0000, 30% opacity)

### Typography
- **Headers**: Bold, 24pt, Sans-serif
- **Body**: Regular, 16pt, Sans-serif
- **Labels**: 12pt, condensed

### Layout
- **Main screen**: Full-screen star map
- **Bottom sheet**: Object info, controls
- **Top bar**: Search, settings, night mode toggle
- **Gestures**:
  - Pinch to zoom
  - Drag to pan
  - Tap to identify
  - Two-finger rotate (optional)

### Screens
1. **Splash screen** (with fun fact)
2. **Main sky map** (full screen)
3. **Search screen** (overlay)
4. **Object detail screen** (bottom sheet)
5. **Settings screen**
6. **Events calendar screen**
7. **Tutorial screens** (first launch)

---

## 📐 Technical Architecture

### Frontend (Flutter)
```
lib/
├── main.dart
├── screens/
│   ├── splash_screen.dart
│   ├── sky_map_screen.dart
│   ├── search_screen.dart
│   ├── object_detail_screen.dart
│   ├── settings_screen.dart
│   ├── events_screen.dart
│   └── tutorial_screen.dart
├── widgets/
│   ├── sky_canvas.dart (star renderer)
│   ├── compass_indicator.dart
│   ├── time_controls.dart
│   ├── search_bar.dart
│   └── object_card.dart
├── models/
│   ├── celestial_object.dart
│   ├── constellation.dart
│   ├── location.dart
│   └── event.dart
├── services/
│   ├── astronomy_service.dart
│   ├── gps_service.dart
│   ├── sensor_service.dart (compass, gyro)
│   ├── ar_service.dart
│   ├── notification_service.dart
│   └── database_service.dart
└── utils/
    ├── coordinate_converter.dart
    ├── projection.dart
    └── time_utils.dart
```

### Backend (Astronomy Engine)
**Option A**: Native Dart (fast, no Python dependency)
**Option B**: Bundled Python (use existing sky_engine.py)
**Recommendation**: Native Dart for mobile (smaller app size, faster)

### Data Storage
- **Star catalog**: SQLite database (9,110 stars)
- **Constellations**: JSON file
- **User data**: SharedPreferences (settings, favorites)
- **Cache**: Object info, images

### Permissions Required
- 📍 **Location**: For GPS coordinates
- 📸 **Camera**: For AR mode
- 🧭 **Sensors**: Compass, accelerometer, gyroscope
- 🔔 **Notifications**: For event alerts

---

## 🏗️ Development Phases

### Phase 1: Core Sky Map (Week 1-2)
- [ ] Basic star map with 100 brightest stars
- [ ] Zoom and pan gestures
- [ ] GPS location integration
- [ ] Date/time picker
- [ ] Dark theme UI

**Deliverable**: App shows accurate star map for current location/time

---

### Phase 2: Full Catalog (Week 3)
- [ ] Import 9,110 star catalog
- [ ] Optimize rendering performance
- [ ] Add planet positions
- [ ] Add Moon with phase
- [ ] Magnitude filtering

**Deliverable**: Complete star catalog with planets

---

### Phase 3: Constellations (Week 4)
- [ ] 20 major constellation lines
- [ ] Constellation labels
- [ ] Toggle on/off
- [ ] Constellation info cards
- [ ] Mythology stories

**Deliverable**: Constellation overlay with info

---

### Phase 4: Search & Identify (Week 5)
- [ ] Search functionality
- [ ] Tap-to-identify objects
- [ ] Object detail cards
- [ ] Rise/set time calculations
- [ ] Bookmark system

**Deliverable**: Full object search and info system

---

### Phase 5: AR Mode (Week 6-7)
- [ ] Camera integration
- [ ] Sensor fusion (GPS + compass + gyro)
- [ ] Real-time overlay
- [ ] Calibration system
- [ ] Screenshot feature

**Deliverable**: Working AR sky overlay

---

### Phase 6: Events & Education (Week 8)
- [ ] Events calendar
- [ ] Notifications
- [ ] Tutorial system
- [ ] Beginner mode
- [ ] Achievement system

**Deliverable**: Educational features complete

---

### Phase 7: Polish & Launch (Week 9-10)
- [ ] Night mode (red tint)
- [ ] Social sharing
- [ ] Performance optimization
- [ ] Bug fixes
- [ ] App store assets (screenshots, descriptions)
- [ ] Beta testing
- [ ] Launch! 🚀

**Deliverable**: Production-ready app on Google Play & App Store

---

## 📊 Success Metrics

### User Engagement
- **Daily Active Users** (DAU)
- **Session duration** (target: 10+ minutes)
- **Feature usage**: AR mode, search, time travel
- **Retention**: Day 1, Day 7, Day 30

### Quality
- **Crash-free rate**: >99%
- **App rating**: 4.5+ stars
- **Performance**: 60 FPS on mid-range devices
- **Battery usage**: <5% per hour

### Growth
- **Downloads**: 10K in first month
- **Reviews**: 100+ positive reviews
- **Shares**: 1K social media shares

---

## 💰 Monetization (Optional)

### Free Version
- All core features
- 100 brightest stars
- 10 major constellations
- Ads (banner at bottom)

### Premium Version ($4.99 one-time)
- Full 9,110 star catalog
- All 88 constellations
- AR mode
- No ads
- Deep space objects
- Telescope control

### In-App Purchases
- 3D planet models ($0.99)
- Additional constellation artwork ($1.99)
- Offline mode ($0.99)
- Advanced features bundle ($2.99)

---

## 🚧 Technical Challenges

### 1. Performance
**Challenge**: Rendering 9K+ stars at 60 FPS on mobile
**Solution**: 
- Level-of-detail (LOD) rendering
- Only render visible stars
- GPU acceleration
- Efficient coordinate calculations

### 2. Battery Usage
**Challenge**: GPS + sensors + rendering = battery drain
**Solution**:
- Reduce GPS polling frequency
- Turn off sensors when app is idle
- Optimize rendering loop
- Battery saver mode option

### 3. AR Accuracy
**Challenge**: Phone sensors drift over time
**Solution**:
- Periodic recalibration
- Use star patterns to self-correct
- User manual adjustment option

### 4. App Size
**Challenge**: 9,110 star catalog + constellation data
**Solution**:
- Compress data files
- On-demand download (premium features)
- Remove duplicate data
- Target: <50MB app size

---

## 📦 Deliverables

### Code
- Complete Flutter mobile app
- 100% documented code
- Unit tests for core calculations
- Integration tests for UI

### Assets
- Star catalog database
- Constellation data files
- UI icons and graphics
- App icon (multiple sizes)

### Documentation
- User guide
- Developer README
- API documentation
- Architecture diagram

### Marketing
- App store screenshots (10+)
- App description (multiple languages)
- Promotional video (1 minute)
- Press kit

---

## 🎯 MVP Definition

**Minimum Viable Product** (launch-ready):

✅ **Must Have**:
1. Real-time star map with 100+ brightest stars
2. GPS location
3. Date/time picker
4. Zoom/pan gestures
5. Tap to identify objects
6. Planet positions
7. Basic constellation lines (10 major)
8. Dark theme
9. Search function
10. Night mode (red tint)

❌ **Can Wait**:
- AR mode (post-launch update)
- Full 9,110 star catalog (premium)
- Events calendar (update)
- 3D planets (premium)
- Deep space objects (update)

---

## 🏁 Launch Checklist

### Pre-Launch
- [ ] All MVP features working
- [ ] Tested on 10+ device models
- [ ] App store accounts created
- [ ] Privacy policy published
- [ ] Terms of service published
- [ ] Marketing materials ready

### App Store Submission
- [ ] Google Play Console setup
- [ ] Apple App Store Connect setup
- [ ] Screenshots uploaded (5+ per platform)
- [ ] App description written
- [ ] Keywords optimized
- [ ] Age rating determined
- [ ] Submit for review

### Post-Launch
- [ ] Monitor crash reports
- [ ] Respond to user reviews
- [ ] Track analytics
- [ ] Plan first update
- [ ] Marketing campaign

---

## 📱 Platform-Specific Notes

### Android
- **Min SDK**: API 24 (Android 7.0, 2016)
- **Target SDK**: API 34 (Android 14)
- **ARCore**: Requires ARCore-compatible device
- **Distribution**: Google Play Store

### iOS
- **Min version**: iOS 13.0
- **Target**: iOS 17
- **ARKit**: Requires iPhone 6S or newer
- **Distribution**: Apple App Store

---

## 🎊 Why This Will Succeed

### Unique Value Proposition
✨ **Most accurate mobile planetarium** (9,110 stars)
✨ **Beautiful, intuitive UI** (better than competitors)
✨ **Offline-capable** (works without internet)
✨ **Educational** (learn while you explore)
✨ **AR mode** (point and identify in real-time)

### Competitive Advantages
- ✅ More stars than most competitors (9K vs 2K)
- ✅ Faster rendering (custom engine)
- ✅ Better accuracy (scientific data)
- ✅ Cleaner UI (modern Flutter design)
- ✅ Educational features (tutorials, quizzes)

### Market Size
- **3 billion** smartphone users worldwide
- **100 million+** people interested in astronomy
- **Top astronomy apps** have 1M-10M downloads
- **Potential**: 100K+ downloads in first year

---

## 🚀 Let's Build It!

**Ready to start?** Let's begin with Phase 1: Core Sky Map.

**Next steps**:
1. Set up Flutter mobile project
2. Implement basic star renderer
3. Add GPS integration
4. Build core UI
5. Test on real devices

**Timeline**: 10 weeks to launch 🎯

**The stars are waiting! ✨🌟📱**
