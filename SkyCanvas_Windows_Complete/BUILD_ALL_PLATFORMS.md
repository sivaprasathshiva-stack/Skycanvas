## Building SkyCanvas for All Platforms

Complete guide to build SkyCanvas for Windows, macOS, Linux, Android, and iOS.

---

## Prerequisites

### All Platforms
- Git
- Flutter SDK 3.24+
- Python 3.9+

### Windows
- Visual Studio 2022 (with C++ desktop development)
- Flutter Windows desktop enabled

### macOS
- Xcode 14+
- CocoaPods
- Flutter macOS desktop enabled

### Linux
- Clang
- CMake
- Ninja-build
- GTK 3.0 development libraries

### Android
- Android Studio
- Android SDK 21+
- Java JDK 11+

### iOS
- macOS (required)
- Xcode 14+
- Apple Developer account ($99/year)

---

## 1. Windows Desktop Build

### Setup
```bash
# Enable Windows desktop
flutter config --enable-windows-desktop

# Install Python dependencies
cd python
pip install -r requirements.txt
cd ..

# Install Flutter dependencies
flutter pub get
```

### Build Release
```bash
# Build Windows executable
flutter build windows --release

# Output location:
# build/windows/x64/runner/Release/
```

### Create Installer (Optional)
```bash
# Install MSIX packaging tool
flutter pub add msix

# Build MSIX package
flutter pub run msix:create

# Output: build/windows/runner/Release/skycanvas.msix
```

### Test
```bash
flutter run -d windows
```

---

## 2. macOS Desktop Build

**Requires**: macOS machine

### Setup
```bash
# Enable macOS desktop
flutter config --enable-macos-desktop

# Install dependencies
cd python
pip3 install -r requirements.txt
cd ..

flutter pub get
cd macos
pod install
cd ..
```

### Build Release
```bash
# Build macOS app
flutter build macos --release

# Output location:
# build/macos/Build/Products/Release/SkyCanvas.app
```

### Code Signing (For Distribution)
```bash
# Sign with Apple Developer certificate
codesign --deep --force --verify --verbose \
  --sign "Developer ID Application: Your Name" \
  build/macos/Build/Products/Release/SkyCanvas.app

# Create DMG for distribution
# (Use create-dmg tool or Disk Utility)
```

### Test
```bash
flutter run -d macos
```

---

## 3. Linux Desktop Build

**Requires**: Linux machine (Ubuntu/Debian recommended)

### Setup
```bash
# Install dependencies
sudo apt-get update
sudo apt-get install -y \
  clang cmake ninja-build pkg-config \
  libgtk-3-dev liblzma-dev \
  libstdc++-12-dev

# Enable Linux desktop
flutter config --enable-linux-desktop

# Install Python and Flutter dependencies
pip3 install -r python/requirements.txt
flutter pub get
```

### Build Release
```bash
# Build Linux executable
flutter build linux --release

# Output location:
# build/linux/x64/release/bundle/
```

### Create AppImage (Optional)
```bash
# Download appimagetool
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage

# Create AppImage directory structure
mkdir -p SkyCanvas.AppDir/usr/bin
cp -r build/linux/x64/release/bundle/* SkyCanvas.AppDir/usr/bin/
# Add desktop file and icon
# ...

# Build AppImage
./appimagetool-x86_64.AppImage SkyCanvas.AppDir
```

### Test
```bash
flutter run -d linux
```

---

## 4. Android Build

### Setup
```bash
# Create Android project (if not exists)
flutter create --platforms=android .

# Install dependencies
flutter pub get
```

### Build APK (Testing)
```bash
# Build debug APK
flutter build apk --debug

# Output: build/app/outputs/flutter-apk/app-debug.apk
```

### Build AAB (Production - Google Play)
```bash
# Build release AAB
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### Signing (Required for Release)

Create `android/key.properties`:
```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=skycanvas
storeFile=/path/to/keystore.jks
```

Generate keystore:
```bash
keytool -genkey -v -keystore skycanvas-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias skycanvas
```

Update `android/app/build.gradle`:
```gradle
android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### Test
```bash
# On connected device
flutter run -d android

# On emulator
flutter emulators --launch <emulator_id>
flutter run
```

---

## 5. iOS Build

**Requires**: macOS + Xcode + Apple Developer Account

### Setup
```bash
# Create iOS project (if not exists)
flutter create --platforms=ios .

# Install dependencies
flutter pub get
cd ios
pod install
cd ..
```

### Open Xcode
```bash
open ios/Runner.xcworkspace
```

In Xcode:
1. Select Runner project
2. Change Bundle Identifier: `com.yourname.skycanvas`
3. Select your Team (Apple Developer account)
4. Configure Signing & Capabilities

### Build for Testing
```bash
# On connected iPhone
flutter run -d ios

# On simulator
flutter run -d iPhone
```

### Build for Distribution (App Store)
```bash
# Build IPA
flutter build ipa --release

# Output: build/ios/ipa/skycanvas.ipa
```

### Upload to App Store
```bash
# Via Xcode
# Product → Archive → Upload to App Store

# Or via command line
xcrun altool --upload-app \
  --file build/ios/ipa/skycanvas.ipa \
  --type ios \
  --username your@email.com \
  --password your-app-specific-password
```

---

## 6. Mobile Remote Control App

Separate Flutter app for Android/iOS remote control.

### Location
```
mobile_remote/
```

### Build Android APK
```bash
cd mobile_remote
flutter build apk --release
```

### Build iOS
```bash
cd mobile_remote
flutter build ios --release
```

---

## Build All Platforms (Automated)

### Using GitHub Actions

The repository includes `.github/workflows/release.yml` that automatically builds:
- Windows (x64)
- macOS (Universal)
- Linux (x64)

Triggered by pushing a tag:
```bash
git tag v0.1.0
git push origin v0.1.0
```

Artifacts are uploaded to GitHub Releases.

---

## Build Checklist

### Before Building
- [ ] Update version in `pubspec.yaml`
- [ ] Update CHANGELOG.md
- [ ] Test on target platform
- [ ] Update documentation
- [ ] Create git tag

### Desktop Platforms
- [ ] Windows: Test on Windows 10/11
- [ ] macOS: Test on macOS 11+
- [ ] Linux: Test on Ubuntu 22.04+

### Mobile Platforms
- [ ] Android: Test on Android 8.0+
- [ ] iOS: Test on iOS 15+

### Distribution
- [ ] Windows: MSIX or ZIP
- [ ] macOS: DMG with code signing
- [ ] Linux: AppImage or tar.gz
- [ ] Android: AAB for Play Store, APK for direct download
- [ ] iOS: IPA for App Store

---

## Platform-Specific Notes

### Windows
- Requires Visual C++ Redistributable on user machines
- MSIX requires certificate for installation
- Antivirus may flag first run

### macOS
- Must be code-signed for distribution
- Users must allow app in Security & Privacy settings
- Requires notarization for macOS 10.15+

### Linux
- Different distributions may need different builds
- AppImage is most portable format
- May require installing libgtk-3-0

### Android
- Minimum SDK 21 (Android 5.0)
- Requires location permission for GPS
- Requires local network permission for discovery

### iOS
- Requires Apple Developer Program membership
- App Store review takes 1-7 days
- TestFlight for beta testing

---

## Troubleshooting

### Build Failed: Python Dependencies
```bash
pip install --upgrade pip
pip install -r python/requirements.txt
```

### Build Failed: Flutter Dependencies
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Build Failed: Platform Not Enabled
```bash
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop
```

### Build Failed: Missing SDK
- Windows: Install Visual Studio 2022
- macOS: Install Xcode from App Store
- Linux: `sudo apt-get install clang cmake ninja-build libgtk-3-dev`

---

## Build Sizes (Approximate)

| Platform | Debug | Release | Compressed |
|----------|-------|---------|------------|
| Windows | 80 MB | 25 MB | 15 MB |
| macOS | 90 MB | 30 MB | 18 MB |
| Linux | 70 MB | 22 MB | 14 MB |
| Android | 45 MB | 18 MB | 12 MB |
| iOS | 50 MB | 20 MB | 14 MB |

---

## Distribution Formats

| Platform | Format | Extension | Notes |
|----------|--------|-----------|-------|
| Windows | MSIX | .msix | Microsoft Store format |
| Windows | ZIP | .zip | Portable, no installer |
| macOS | DMG | .dmg | Disk image with app |
| macOS | ZIP | .zip | Direct app bundle |
| Linux | AppImage | .AppImage | Portable, no install |
| Linux | TAR.GZ | .tar.gz | Manual extraction |
| Android | AAB | .aab | Play Store only |
| Android | APK | .apk | Direct install |
| iOS | IPA | .ipa | App Store / TestFlight |

---

## Next Steps

After building:
1. Test on target platform
2. Create release notes
3. Tag git version
4. Upload to distribution channels
5. Update website/documentation

See [PUBLISHING.md](PUBLISHING.md) for distribution guide.
