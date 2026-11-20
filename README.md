# Hackstat

> Your coding stats, beautifully. A gorgeous iOS client for [Hackatime](https://hackatime.hackclub.com) with iOS 27-inspired glassmorphic UI.

[![Build iOS](https://github.com/FBIopeningUPP/hackatime-ios/actions/workflows/build-ios.yml/badge.svg)](https://github.com/FBIopeningUPP/hackatime-ios/actions/workflows/build-ios.yml)
![iOS 17+](https://img.shields.io/badge/iOS-17%2B-blue?logo=apple)
![Flutter](https://img.shields.io/badge/Flutter-3.24-02569B?logo=flutter)
![License](https://img.shields.io/badge/License-MIT-green)

<!-- Screenshots - add after running the app
<p align="center">
  <img src="assets/screenshot_home.png" width="250" alt="Home Screen"/>
  <img src="assets/screenshot_setup.png" width="250" alt="Setup Screen"/>
</p>
-->

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🎨 **iOS 27 UI** | Glassmorphic cards, blur effects, smooth animations |
| 📊 **Activity Charts** | Beautiful bar charts for daily coding activity |
| 🌈 **Languages** | Colorful progress bars for each language |
| 📁 **Projects** | Ranked by time spent |
| 🔧 **Editors** | Track VS Code, Vim, JetBrains, etc. |
| 🔄 **Pull to Refresh** | Instantly update stats |
| 🌙 **Dark Mode** | OLED-optimized |

## 📱 Install

### Quick Install

1. Go to [**Actions → Latest Build**](../../actions)
2. Download **Hackstat-iOS** artifact
3. Install `.ipa` via **iLoader** / **SideStore** / **AltStore**

### Build Yourself

```bash
git clone https://github.com/FBIopeningUPP/hackatime-ios.git
cd hackatime-ios
flutter pub get
flutter build ios --release --no-codesign  # Requires macOS
```

## 🔧 Setup

1. Get API key → [hackatime.hackclub.com/settings](https://hackatime.hackclub.com/settings)
2. Launch Hackstat
3. Paste key & connect
4. 🎉

## 🏗️ Structure

```
lib/
├── main.dart           # Entry point
├── models/             # Data models
├── screens/            # Home & Setup screens
├── services/           # API client
├── theme/              # iOS 27 theme
└── widgets/            # Glass cards & charts
```

## 🔌 Compatibility

- ✅ [Hackatime](https://hackatime.hackclub.com)
- ✅ [Wakapi](https://wakapi.dev)
- ✅ [WakaTime](https://wakatime.com)

## 📄 License

MIT — do whatever you want!

---

<p align="center">
  Made with 💜 for <a href="https://hackclub.com">Hack Club</a>
</p>
