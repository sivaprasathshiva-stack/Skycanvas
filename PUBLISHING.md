# SkyCanvas Publishing Guide

Complete guide to publish SkyCanvas on all platforms.

---

## 📦 Distribution Channels

| Platform | Channel | Cost | Review Time | Auto-Updates |
|----------|---------|------|-------------|--------------|
| **Windows** | Microsoft Store | $19 one-time | 1-3 days | ✅ |
| **Windows** | GitHub Releases | Free | Instant | Manual |
| **Windows** | itch.io | Free | Instant | Manual |
| **macOS** | Mac App Store | $99/year | 1-3 days | ✅ |
| **macOS** | GitHub Releases | Free | Instant | Manual |
| **Android** | Google Play | $25 one-time | 1-2 days | ✅ |
| **Android** | APK (Direct) | Free | Instant | Manual |
| **iOS** | App Store | $99/year | 1-3 days | ✅ |

---

## 🆓 Free Distribution (Recommended for v0.1)

### Option 1: GitHub Releases (Best for Alpha/Beta)

**Advantages**:
- ✅ Free
- ✅ Instant publishing
- ✅ Version control
- ✅ Automated via GitHub Actions
- ✅ Direct download links

**Setup**:
```bash
# Tag a release
git tag -a v0.1.0 -m "Initial alpha release"
git push origin v0.1.0

# GitHub Actions will auto-build and publish
```

### Option 2: itch.io (Great for Gaming Community)

**Advantages**:
- ✅ Free
- ✅ No review process
- ✅ Optional donations
- ✅ Good discoverability

**Setup**:
1. Create account at https://itch.io
2. Create new project
3. Upload builds
4. Set price (free or pay-what-you-want)

### Option 3: Direct Website

**Advantages**:
- ✅ Full control
- ✅ No middleman
- ✅ Free hosting (GitHub Pages)

**Setup**:
```bash
# Build for Windows
flutter build windows --release

# Upload to GitHub Pages
# Users download from: https://yourusername.github.io/skycanvas
```

---

## 💰 Paid App Stores (For v1.0)

### Microsoft Store (Windows)

**Requirements**:
- ✅ Microsoft Developer Account ($19 one-time)
- ✅ MSIX package
- ✅ Privacy policy
- ✅ App screenshots (4+)
- ✅ App description

**Build Process**:
```bash
# Install MSIX tools
flutter pub add msix

# Configure pubspec.yaml
msix_config:
  display_name: SkyCanvas
  publisher_display_name: Your Name
  identity_name: com.yourname.skycanvas
  logo_path: assets/icon.png

# Build MSIX
flutter pub run msix:create

# Upload to Microsoft Partner Center
```

**Estimated Timeline**:
- Setup: 1 day
- Review: 1-3 days
- **Total: 2-4 days**

### Mac App Store (macOS)

**Requirements**:
- ✅ Apple Developer Account ($99/year)
- ✅ macOS for building
- ✅ Code signing certificate
- ✅ App Store Connect account
- ✅ Privacy policy

**Build Process**:
```bash
# Build for macOS
flutter build macos --release

# Create app bundle
# Sign with Apple Developer certificate
# Upload via Transporter app
```

**Estimated Timeline**:
- Setup: 2-3 days
- Review: 1-7 days
- **Total: 3-10 days**

### Google Play Store (Android)

**Requirements**:
- ✅ Google Play Developer Account ($25 one-time)
- ✅ Privacy policy
- ✅ App screenshots
- ✅ Feature graphic
- ✅ Content rating questionnaire

**Build Process**:
```bash
# Build AAB (Android App Bundle)
flutter build appbundle --release

# Upload to Google Play Console
# Fill out store listing
# Submit for review
```

**Estimated Timeline**:
- Setup: 1 day
- Review: 1-3 days
- **Total: 2-4 days**

### Apple App Store (iOS)

**Requirements**:
- ✅ Apple Developer Account ($99/year)
- ✅ macOS + Xcode
- ✅ Privacy policy
- ✅ App screenshots (multiple sizes)
- ✅ App Store Connect listing

**Build Process**:
```bash
# Build for iOS
flutter build ios --release

# Archive in Xcode
# Upload via Xcode
# Submit for review
```

**Estimated Timeline**:
- Setup: 2-3 days
- Review: 1-7 days
- **Total: 3-10 days**

---

## 📋 Pre-Publishing Checklist

### Required Assets

#### App Icons
- [ ] Windows: 1024x1024 PNG
- [ ] macOS: 1024x1024 PNG
- [ ] Android: 512x512 PNG
- [ ] iOS: 1024x1024 PNG

#### Screenshots
- [ ] Windows: 1920x1080 (4+ screenshots)
- [ ] macOS: 2880x1800 (4+ screenshots)
- [ ] Android: 1920x1080 (2+ screenshots)
- [ ] iOS: Multiple sizes (6.5", 5.5", 12.9")

#### Marketing Assets
- [ ] Feature graphic: 1024x500 (Google Play)
- [ ] Promotional images
- [ ] App preview video (optional)
- [ ] App icon variations

### Legal Documents
- [x] Privacy Policy (DONE)
- [x] Terms of Service (DONE)
- [x] License (MIT) (DONE)
- [ ] GDPR compliance statement
- [ ] Age rating documentation

### Technical Requirements
- [ ] All features tested
- [ ] No critical bugs
- [ ] Performance optimized
- [ ] Crash rate <1%
- [ ] Works offline (after initial setup)
- [ ] Supports multiple screen sizes

### Store Listings
- [ ] App name (35 char limit)
- [ ] Short description (80 char)
- [ ] Full description (4000 char)
- [ ] Keywords/tags
- [ ] Category selection
- [ ] Age rating
- [ ] Support URL
- [ ] Privacy policy URL

---

## 📝 Store Listing Content

### App Name
**Primary**: SkyCanvas  
**Alternatives**: 
- SkyCanvas - Live Planetarium
- SkyCanvas: Sky Projection
- SkyCanvas - Astronomy Projector

### Short Description (80 chars)
"Turn any projector into a window to the universe. Real-time sky on your ceiling."

### Full Description (Sample)

```
Turn Any Projector Into A Window To The Universe

SkyCanvas transforms your projector, TV, or monitor into a live planetarium showing the real night sky with scientific accuracy.

✨ FEATURES
• Real-time sky based on your location
• 9,110+ stars with accurate positions
• All planets (Mercury, Venus, Mars, Jupiter, Saturn)
• Moon with current phase
• Historical sky replay - see the sky from any date
• Constellation lines and labels
• HDMI output to any projector
• Chromecast and AirPlay support
• Offline mode (after initial setup)

🌟 PERFECT FOR
• Astronomy enthusiasts
• Home theater owners
• Families with children
• Teachers and educators
• Meditation and relaxation
• Bedtime routines

🔬 SCIENTIFICALLY ACCURATE
Uses NASA JPL data and professional astronomy libraries (Skyfield) for precise celestial calculations.

📺 UNIVERSAL COMPATIBILITY
Works with ANY projector, TV, or monitor via:
• HDMI cable
• Chromecast
• Apple AirPlay
• Miracast

🎓 EDUCATIONAL
Perfect for teaching:
• Constellation recognition
• Planet positions
• Lunar phases
• Celestial mechanics

🆓 100% FREE
No subscriptions. No ads. No data collection.
Open source MIT license.

📱 CROSS-PLATFORM
• Windows 10/11
• macOS 11+
• Android 8.0+
• iOS 15+

🌍 WORKS ANYWHERE
Automatically calculates the correct sky for your location and time zone.

📖 OPEN SOURCE
Full source code available on GitHub. Privacy-first design - zero data collection.

---

Download SkyCanvas today and bring the universe into your home! ✨
```

### Keywords/Tags
```
astronomy, planetarium, stars, planets, projector, sky, space, 
constellation, night sky, cosmos, celestial, moon, educational,
projection mapping, home theater, chromecast, airplay, hdmi
```

### Categories
- **Primary**: Education
- **Secondary**: Entertainment
- **Tertiary**: Lifestyle (for meditation/sleep features)

---

## 🎨 Asset Creation Guide

### App Icon Requirements

**Design Principles**:
- Simple and recognizable
- Works at all sizes (16px to 1024px)
- No text (or minimal)
- High contrast
- Memorable

**Suggested Design**:
```
Dark blue gradient background
White/yellow stars pattern
Minimalist constellation shape
```

**Tools**:
- Figma (free)
- Canva (free)
- Adobe Illustrator
- GIMP (free)

### Screenshot Guidelines

**Must Include**:
1. Main sky view (full screen of stars)
2. Control panel + sky split view
3. Planet close-up
4. Constellation labels
5. Date picker in action
6. Projector output (photo of ceiling)

**Best Practices**:
- Use dark backgrounds
- Add captions/annotations
- Show key features
- Professional quality
- Consistent style

---

## 🚀 Automated Publishing

### GitHub Actions (Recommended)

Create `.github/workflows/release.yml`:

```yaml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  build-windows:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build windows --release
      - uses: actions/upload-artifact@v3
        with:
          name: windows-build
          path: build/windows/runner/Release/

  build-macos:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build macos --release
      - uses: actions/upload-artifact@v3
        with:
          name: macos-build
          path: build/macos/Build/Products/Release/

  create-release:
    needs: [build-windows, build-macos]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v3
      - uses: softprops/action-gh-release@v1
        with:
          files: |
            windows-build/**
            macos-build/**
```

### Automatic Version Bumping

Create `scripts/bump_version.sh`:

```bash
#!/bin/bash
# Increment version in pubspec.yaml
# Create git tag
# Push to trigger build
```

---

## 📊 Post-Launch Checklist

### Day 1
- [ ] Announce on GitHub
- [ ] Post on Reddit (r/astronomy, r/space, r/projectors)
- [ ] Tweet announcement
- [ ] Post on Product Hunt
- [ ] Share on Hacker News

### Week 1
- [ ] Monitor crash reports
- [ ] Respond to GitHub issues
- [ ] Collect user feedback
- [ ] Fix critical bugs

### Month 1
- [ ] Release v0.2 with top-requested features
- [ ] Write blog post about development
- [ ] Create video tutorial
- [ ] Reach out to astronomy YouTubers

---

## 💡 Marketing Strategy

### Free Channels
1. **Reddit**: r/astronomy, r/space, r/hometheater
2. **Hacker News**: Show HN post
3. **Product Hunt**: Featured launch
4. **GitHub**: Trending repositories
5. **YouTube**: Tutorial videos
6. **Twitter/X**: Developer updates
7. **Discord**: Astronomy communities

### Paid Channels (Optional)
1. Google Ads: $100-500/month
2. Facebook Ads: $100-500/month
3. App Store search ads: $50-200/month

### Content Marketing
- Write blog posts about astronomy
- Create tutorial videos
- Guest posts on astronomy sites
- Partner with planetariums/schools

---

## 📈 Success Metrics

### Downloads
- Week 1: 100 downloads
- Month 1: 1,000 downloads
- Month 3: 10,000 downloads
- Month 6: 50,000 downloads

### Ratings
- Target: 4.5+ stars
- Goal: 4.8+ stars

### Retention
- 7-day: 40%+
- 30-day: 25%+

### Reviews
- Target: 50+ reviews in first month
- Respond to all reviews

---

## 🎯 Launch Timeline

### Recommended Approach: Staged Launch

**Phase 1: Alpha (Weeks 1-6)**
- Platform: GitHub Releases only
- Audience: Early testers (20-50 users)
- Goal: Find bugs, get feedback

**Phase 2: Beta (Weeks 7-13)**
- Platform: GitHub + itch.io
- Audience: Wider testing (100-500 users)
- Goal: Polish features, collect reviews

**Phase 3: Public v1.0 (Week 20)**
- Platform: All app stores
- Audience: General public
- Goal: 10,000+ downloads

---

## 📄 Required Files for Publishing

### All Platforms
- [x] LICENSE (MIT)
- [x] PRIVACY_POLICY.md
- [x] TERMS_OF_SERVICE.md
- [x] README.md
- [x] CHANGELOG.md
- [x] CONTRIBUTING.md
- [ ] App icon (1024x1024)
- [ ] Screenshots (4+)
- [ ] Feature graphic
- [ ] Demo video

### Windows Specific
- [ ] MSIX configuration
- [ ] Code signing certificate
- [ ] Microsoft Partner Center account

### macOS Specific
- [ ] Apple Developer certificate
- [ ] Provisioning profile
- [ ] App Store Connect account

### Android Specific
- [ ] Keystore file
- [ ] Google Play Console account
- [ ] Content rating questionnaire

### iOS Specific
- [ ] Apple Developer account
- [ ] Provisioning profile
- [ ] App Store Connect account

---

## ✅ You're Ready to Publish!

All legal documents are ready:
- ✅ MIT License
- ✅ Privacy Policy (zero data collection)
- ✅ Terms of Service
- ✅ Contributing guidelines

**Next steps**:
1. Create app icons and screenshots
2. Choose distribution channel(s)
3. Build release versions
4. Publish!

---

**Questions?** See [CONTRIBUTING.md](CONTRIBUTING.md) or open an issue on GitHub.
