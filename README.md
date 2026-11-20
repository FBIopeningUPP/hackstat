# Hackatime

> A beautiful iOS app for viewing your [Hackatime](https://hackatime.hackclub.com) coding stats with an iOS 27-inspired glassmorphic UI.

[![Build iOS](https://github.com/YOUR_USERNAME/hackatime-ios/actions/workflows/build-ios.yml/badge.svg)](https://github.com/YOUR_USERNAME/hackatime-ios/actions/workflows/build-ios.yml)
![iOS 17+](https://img.shields.io/badge/iOS-17%2B-blue?logo=apple)
![Flutter](https://img.shields.io/badge/Flutter-3.24-02569B?logo=flutter)
![License](https://img.shields.io/badge/License-MIT-green)

<!-- Add your screenshots here after running the app -->
<!--
<p align="center">
  <img src="assets/screenshot_home.png" width="250" alt="Home Screen"/>
  <img src="assets/screenshot_setup.png" width="250" alt="Setup Screen"/>
  <img src="assets/screenshot_languages.png" width="250" alt="Languages"/>
</p>
-->

## ✨ Features

- 🎨 **iOS 27 Style UI** — Glassmorphic cards with blur effects and smooth animations
- 📊 **Activity Charts** — Beautiful bar charts showing daily coding activity
- 🌈 **Language Breakdown** — Colorful progress bars for each programming language
- 📁 **Project Stats** — See which projects you spend the most time on
- 🔧 **Editor Tracking** — Track time across VS Code, Vim, JetBrains, etc.
- 🔄 **Pull to Refresh** — Instantly update your stats
- 🌙 **Dark Mode** — Optimized for OLED displays
- ⚡ **Fast & Lightweight** — Built with Flutter for smooth 60fps animations

## 📱 Installation

### Download IPA (Recommended)

1. Go to [**Actions**](../../actions) tab
2. Click the latest successful build
3. Download **Hackatime-iOS** artifact
4. Unzip to get `Hackatime-unsigned.ipa`
5. Install using **iLoader**, **SideStore**, or **AltStore**

### Build from Source

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/hackatime-ios.git
cd hackatime-ios

# Get dependencies
flutter pub get

# Build (requires macOS with Xcode)
flutter build ios --release --no-codesign

# Create IPA
cd build/ios/iphoneos
mkdir Payload && cp -r Runner.app Payload/
zip -r Hackatime.ipa Payload
```

## 🔧 Setup

1. **Get your API key** from [hackatime.hackclub.com/settings](https://hackatime.hackclub.com/settings)
2. **Launch the app** on your iPhone
3. **Paste your API key** and tap Connect
4. **Enjoy your stats!** 🎉

### Custom Server (Optional)

Using your own Hackatime/Wakapi instance? Tap "Advanced options" on the setup screen to enter your server URL.

## 🏗️ Project Structure

```
lib/
├── main.dart              # App entry point & routing
├── models/
│   └── stats_model.dart   # Data models for API responses
├── screens/
│   ├── home_screen.dart   # Main dashboard with stats
│   └── setup_screen.dart  # API key configuration
├── services/
│   └── api_service.dart   # Hackatime API client
├── theme/
│   └── app_theme.dart     # iOS 27 style theme & colors
└── widgets/
    ├── glass_card.dart    # Glassmorphic card components
    └── stat_widgets.dart  # Charts & stat displays
```

## 🎨 Design

The UI is inspired by iOS 27's design language:

| Element | Implementation |
|---------|----------------|
| **Glassmorphism** | `BackdropFilter` with blur + semi-transparent backgrounds |
| **Gradients** | Radial gradients for depth, linear for cards |
| **Typography** | SF Pro Display with tight letter-spacing |
| **Animations** | `TweenAnimationBuilder` for smooth entrance effects |
| **Colors** | Apple's SF Symbols color palette |

## 📊 API Compatibility

Works with any WakaTime-compatible API:
- ✅ [Hackatime](https://hackatime.hackclub.com) (Hack Club)
- ✅ [Wakapi](https://wakapi.dev)
- ✅ [WakaTime](https://wakatime.com) (with API key)

## 🤝 Contributing

Contributions welcome! Feel free to:
- 🐛 Report bugs
- 💡 Suggest features
- 🔧 Submit PRs

## 📄 License

MIT License — do whatever you want with it!

## 🙏 Credits

- [Hackatime](https://hackatime.hackclub.com) by [Hack Club](https://hackclub.com)
- [Flutter](https://flutter.dev) by Google
- [fl_chart](https://pub.dev/packages/fl_chart) for beautiful charts

---

<p align="center">
  Made with 💜 for the Hack Club community
</p>
