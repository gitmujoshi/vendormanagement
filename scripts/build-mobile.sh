#!/bin/bash
# @file build-mobile.sh
# @description Build mobile applications for both platforms

set -e

# Load environment variables
source .env

# Build Android
echo "Building Android app..."
cd android
./gradlew assembleRelease

# Build iOS (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Building iOS app..."
  cd ../ios
  pod install
  xcodebuild -workspace YourApp.xcworkspace -scheme YourApp -configuration Release
else
  echo "Skipping iOS build (not on macOS)"
fi

echo "Mobile builds completed!" 