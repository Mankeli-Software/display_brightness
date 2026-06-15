# device_brightness_example

Demonstrates how to use the device_brightness package.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## iOS & macOS Codesigning (Local Setup)

To avoid committing personal Apple Development Team IDs to this repository, the project uses an optional configuration injection strategy.

To run the example app locally on a physical iOS device:

1. Create a local configuration file at the following path (this file is already ignored by Git):
   - `example/ios/Flutter/Local.xcconfig`

2. Add your Apple Development Team ID to this file:
   ```properties
   DEVELOPMENT_TEAM = YOUR_TEAM_ID
   ```
   *(Replace `YOUR_TEAM_ID` with your actual 10-character Apple Developer Team ID, which can be found in the Apple Developer Account Portal).*

