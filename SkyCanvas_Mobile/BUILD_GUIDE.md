# 🏗️ SkyCanvas Mobile - Complete Build Guide

**Last Updated**: June 25, 2026  
**Status**: Ready to Build

---

## 📋 Prerequisites

### Required Software

| Tool | Version | Download |
|------|---------|----------|
| **Flutter SDK** | 3.0+ | https://flutter.dev/docs/get-started/install |
| **Dart SDK** | 3.0+ | Included with Flutter |
| **Android Studio** | Latest | https://developer.android.com/studio |
| **Xcode** | 14+ | Mac App Store (macOS only) |
| **Git** | Latest | https://git-scm.com/ |

### For Android Development
- Java JDK 11+
- Android SDK (API 24-34)
- Android Emulator or physical device

### For iOS Development (macOS only)
- CocoaPods
- iOS Simulator or physical device
- Apple Developer account (for device testing)

---

## 🔧 Setup Instructions

### 1. Install Flutter

#### Windows
```bash
# Using Scoop (recommended)
scoop install flutter

# Or download from flutter.dev
```

#### macOS
```bash
# Using Homebrew
brew install flutter

# Or download from flutter.dev
```

#### Linux
```bash
# Download and extract
cd ~/development
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.x.x-stable.tar.xz
tar xf flutter_linux_*.tar.xz

# Add to PATH
export PATH="$PATH:`pwd`/flutter/bin"
```

### 2. Verify Installation

```bash
flutter doctor
```

Fix any issues shown before proceeding.

### 3. Clone/Navigate to Project

```bash
cd c:/Users/ssivakumar/Sky/SkyCanvas_Mobile
```

### 4. Install Dependencies

```bash
flutter pub get
```

This installs all packages from `pubspec.yaml`.

---

## 🤖 Android Build

### Development Build

```bash
# Run on connected device
flutter run -d android

# Run in release mode
flutter run --release -d android

# Run on specific device
flutter devices  # List devices
flutter run -d <device-id>
```

### Production APK

```bash
# Build release APK
flutter build apk --release

# Build split APKs (smaller file size)
flutter build apk --split-per-abi

# Output location:
# build/app/outputs/flutter-apk/app-release.apk
```

### App Bundle (Google Play)

```bash
# Build App Bundle (recommended for Play Store)
flutter build appbundle --release

# Output location:
# build/app/outputs/bundle/release/app-release.aab
```

### Signing (for Production)

1. **Create keystore**:
```bash
keytool -genkey -v -keystore ~/skycanvas-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias skycanvas
```

2. **Create `android/key.properties`**:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=skycanvas
storeFile=<path-to-keystore>
```

3. **Update `android/app/build.gradle`**:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

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

4. **Build signed APK/Bundle**:
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

---

## 🍎 iOS Build

### Prerequisites (macOS only)

```bash
# Install CocoaPods
sudo gem install cocoapods

# Install iOS dependencies
cd ios
pod install
cd ..
```

### Development Build

```bash
# Run on simulator
flutter run -d ios

# Run on physical device (requires Apple Developer account)
flutter run -d <device-id>
```

### Production Build

```bash
# Build for release
flutter build ios --release
```

### App Store Submission

1. **Open in Xcode**:
```bash
open ios/Runner.xcworkspace
```

2. **Configure in Xcode**:
   - Select **Product > Archive**
   - Wait for archive to complete
   - **Window > Organizer** to see archives
   - Click **Distribute App**
   - Choose **App Store Connect**
   - Follow wizard

3. **App Store Connect**:
   - https://appstoreconnect.apple.com
   - Create app listing
   - Upload build from Xcode
   - Submit for review

---

## 🧪 Testing

### Run Tests

```bash
# Unit tests
flutter test

# Integration tests
flutter drive --target=test_driver/app.dart
```

### Test on Emulators

```bash
# List available emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator-id>

# Run app
flutter run
```

### Test on Physical Devices

```bash
# Android: Enable USB debugging on device
adb devices  # Verify device is connected
flutter run

# iOS: Trust computer on device
flutter devices  # Verify device shows
flutter run -d <device-id>
```

---

## 🎨 Assets & Icons

### App Icon

1. **Prepare icon**: 1024x1024 PNG
2. **Use flutter_launcher_icons**:

Add to `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/app_icon.png"
```

3. **Generate**:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

### Splash Screen

1. **Prepare image**: 1242x2688 PNG
2. **Use flutter_native_splash**:

```yaml
dev_dependencies:
  flutter_native_splash: ^2.3.10

flutter_native_splash:
  color: "#000000"
  image: assets/images/splash.png
  android: true
  ios: true
```

3. **Generate**:
```bash
flutter pub run flutter_native_splash:create
```

---

## 📊 Build Size Optimization

### Reduce APK Size

```bash
# Split by ABI
flutter build apk --split-per-abi

# Tree shake icons
flutter build apk --release --tree-shake-icons

# Target specific platforms
flutter build apk --target-platform android-arm64
```

### Obfuscation

```bash
flutter build apk --release --obfuscate --split-debug-info=/<directory>
```

---

## 🐛 Common Build Issues

### Issue: "Flutter SDK not found"
```bash
# Solution: Add Flutter to PATH
export PATH="$PATH:/path/to/flutter/bin"
```

### Issue: "Android licenses not accepted"
```bash
# Solution:
flutter doctor --android-licenses
```

### Issue: "CocoaPods not installed"
```bash
# Solution:
sudo gem install cocoapods
```

### Issue: "Gradle build failed"
```bash
# Solution: Clean and rebuild
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

### Issue: "iOS build fails"
```bash
# Solution: Update pods
cd ios
pod repo update
pod install
cd ..
flutter clean
flutter build ios
```

---

## 🚀 Release Checklist

### Pre-Release
- [ ] Test on multiple devices (Android & iOS)
- [ ] Test different screen sizes
- [ ] Test permissions (GPS, etc.)
- [ ] Verify all features work
- [ ] Check performance (no lag)
- [ ] Test offline functionality
- [ ] Verify night mode works
- [ ] Test search functionality
- [ ] Verify GPS accuracy
- [ ] Check time travel feature

### App Store Preparation
- [ ] App icon (1024x1024)
- [ ] Screenshots (all required sizes)
- [ ] App description (catchy, clear)
- [ ] Keywords (astronomy, stars, planets)
- [ ] Privacy policy URL
- [ ] Support URL/email
- [ ] Age rating (4+)
- [ ] Category (Education/Reference)

### Android (Google Play)
- [ ] Build signed App Bundle
- [ ] Create store listing
- [ ] Upload screenshots (5+)
- [ ] Write description (4000 chars max)
- [ ] Short description (80 chars)
- [ ] Content rating questionnaire
- [ ] Set pricing (free/paid)
- [ ] Select countries
- [ ] Submit for review

### iOS (App Store)
- [ ] Archive build in Xcode
- [ ] Upload to App Store Connect
- [ ] Create app listing
- [ ] Upload screenshots (all sizes)
- [ ] Write description
- [ ] Set pricing
- [ ] Select countries
- [ ] Submit for review

---

## 📦 Build Artifacts

### Android
- **Debug APK**: `build/app/outputs/flutter-apk/app-debug.apk`
- **Release APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **App Bundle**: `build/app/outputs/bundle/release/app-release.aab`

### iOS
- **Debug**: `build/ios/iphoneos/Runner.app`
- **Release**: Archive via Xcode
- **IPA**: Exported from Xcode Organizer

---

## 🔄 CI/CD (Optional)

### GitHub Actions (Example)

Create `.github/workflows/build.yml`:

```yaml
name: Build and Release

on:
  push:
    branches: [ main ]

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
      - run: flutter pub get
      - run: flutter test
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v3
        with:
          name: android-apk
          path: build/app/outputs/flutter-apk/app-release.apk

  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
      - run: flutter pub get
      - run: flutter test
      - run: flutter build ios --release --no-codesign
```

---

## 📈 Performance Profiling

### Analyze Build

```bash
# Build with profile mode
flutter build apk --profile

# Run in profile mode
flutter run --profile

# Analyze bundle size
flutter build apk --analyze-size
```

### Performance Testing

```bash
# Run performance tests
flutter drive --profile --target=test_driver/perf_test.dart

# Generate timeline
flutter run --profile --trace-startup
```

---

## ✅ Final Verification

Before submitting:

1. **Run on real devices** (not just emulators)
2. **Test all features** thoroughly
3. **Check crash reports** (if beta testing)
4. **Verify permissions** work correctly
5. **Test on different OS versions**
6. **Check battery usage**
7. **Verify offline functionality**
8. **Test in different locations** (GPS)
9. **Check night mode** in darkness
10. **Verify store listing** looks good

---

## 🎊 You're Ready!

✅ **Build process documented**  
✅ **All platforms covered**  
✅ **Common issues addressed**  
✅ **Release checklist provided**  

**Time to build and ship! 🚀**
