# Nexora Technologies Mobile App

A Flutter mobile application for Nexora Technologies, compatible with iOS, Android, and Web platforms.

## Download (Android)

Get the latest installable APK — free, no Play Store required:

**https://github.com/kwizerisezerano/nexora-mobile/releases/latest**

On your Android device, open the link, download `app-release.apk`, and tap it to
install (you may need to allow "Install unknown apps" for your browser).

A new APK is published automatically whenever a version tag (e.g. `v1.0.0`) is
pushed — see [Releasing](#releasing).

## Features

- **Cross-platform**: Works on iOS, Android, and Web
- **Material Design 3**: Modern, clean UI matching the website design
- **5 Main Screens**: Home, Services, About, Portfolio, Contact
- **Responsive Design**: Adapts to all screen sizes
- **Green Theme**: Professional green accent color matching the website

## Screens

1. **Home**: Hero section with company stats and CTA buttons
2. **Services**: 6 service cards with descriptions and status
3. **About**: Mission, Vision, and Growth Roadmap
4. **Portfolio**: 6 project showcases with categories
5. **Contact**: Contact information and message form

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio / Xcode (for mobile development)
- Android/iOS device or emulator

### Installation

1. Navigate to the project directory:
   ```bash
   cd nexora-mobile
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Building for Different Platforms

### Android
```bash
flutter build apk
```

### iOS
```bash
flutter build ios
```

### Web
```bash
flutter build web
```

## Project Structure

```
nexora-mobile/
├── lib/
│   ├── main.dart              # App entry point (root only)
│   ├── core/                  # Cross-cutting: settings, site data, utils
│   ├── l10n/                  # Localization (en, fr, sw)
│   ├── screens/               # Tab screens
│   ├── theme/                 # Theme + system typography
│   └── widgets/               # Shared UI primitives
├── android/                   # Android platform files
├── ios/                       # iOS platform files
└── web/                       # Web preview target
```

## Customization

### Colors
The app uses the green theme color `#28A745` (the brand accent). To change this, update the `ColorScheme` in `lib/theme/app_theme.dart`.

### Icons
Currently using Material Icons. To add custom icons:
1. Add `flutter_launcher_icons` to `pubspec.yaml`
2. Run `flutter pub get`
3. Update icon usage in screens

### Adding New Screens
1. Create a new file in `lib/screens/`
2. Add the screen to the `_screens` list in `main.dart`
3. Update the `BottomNavigationBar` items

## Releasing

Android releases are automated by
[`.github/workflows/release-apk.yml`](.github/workflows/release-apk.yml): pushing
a version tag runs analyze + tests, builds `app-release.apk`, and attaches it to
a public GitHub Release.

```bash
git tag v1.0.0
git push origin v1.0.0
```

To build locally instead:

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

### iOS

iOS distribution requires an Apple Developer account ($99/yr) for provisioning
and App Store / TestFlight delivery, so iOS is not part of the free APK pipeline.

## License

© 2026 Nexora Technologies. All rights reserved.
