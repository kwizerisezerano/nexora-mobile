# Nexora Technologies Mobile App

A Flutter mobile application for Nexora Technologies, compatible with iOS, Android, and Web platforms.

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
│   ├── main.dart              # App entry point
│   └── screens/              # Screen widgets
│       ├── home_screen.dart
│       ├── services_screen.dart
│       ├── about_screen.dart
│       ├── portfolio_screen.dart
│       └── contact_screen.dart
├── android/                   # Android specific files
├── ios/                       # iOS specific files
└── web/                       # Web specific files
```

## Customization

### Colors
The app uses the green theme color `#19A657` (similar to the website). To change this, update the `ColorScheme` in `main.dart`.

### Icons
Currently using Material Icons. To add custom icons:
1. Add `flutter_launcher_icons` to `pubspec.yaml`
2. Run `flutter pub get`
3. Update icon usage in screens

### Adding New Screens
1. Create a new file in `lib/screens/`
2. Add the screen to the `_screens` list in `main.dart`
3. Update the `BottomNavigationBar` items

## Publishing

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## License

© 2026 Nexora Technologies. All rights reserved.
