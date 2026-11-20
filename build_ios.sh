#!/bin/bash
# Build script for creating iOS IPA from Linux
# This creates the Flutter iOS build files that iLoader can sign and install

set -e

echo "🔧 Getting Flutter dependencies..."
export PATH="$HOME/flutter/bin:$PATH"
flutter pub get

echo "📱 Building iOS release (no codesign)..."
flutter build ios --release --no-codesign

echo "✅ Build complete!"
echo ""
echo "The iOS build is ready at:"
echo "  ~/hackatime_app/build/ios/iphoneos/Runner.app"
echo ""
echo "To install on your iPhone:"
echo "1. Open iLoader (GUI)"
echo "2. Connect your iPhone via USB"
echo "3. Select the Runner.app or drag it into iLoader"
echo "4. iLoader will sign and install it"
echo ""
echo "Or create an IPA manually:"
echo "  cd build/ios/iphoneos"
echo "  mkdir Payload"
echo "  cp -r Runner.app Payload/"
echo "  zip -r Hackatime.ipa Payload"
