# display_brightness

A Flutter plugin for controlling app-level screen brightness on iOS and Android using direct native interop via **jnigen** (Android) and **swiftgen** (iOS).

## Features

- **Set brightness** — Control the app-level screen brightness (0.0–1.0)
- **Get brightness** — Read the current effective brightness
- **Monitor changes** — Stream of brightness change events
- **No permissions** — Uses app-level APIs that don't require permissions
- **Native-Speed** — Direct JNI/FFI calls, no method channels

## Usage

```dart
import 'package:display_brightness/display_brightness.dart';

// Create a controller (auto-detects platform)
final controller = DisplayBrightnessController();

// Get current brightness
final current = controller.brightness; // 0.0–1.0 (can be null)

// Set brightness
controller.setBrightness(0.8);

// Listen to brightness changes
final subscription = controller.onBrightnessChanged.listen((value) {
  print('Brightness changed: $value');
});

// Cleanup when done
subscription.cancel();
controller.dispose();
```

## API

### `DisplayBrightnessController`

| Method | Description |
|---|---|
| `double? get brightness` | Current effective brightness (0.0–1.0), or `null` if it cannot be read |
| `void setBrightness(double value)` | Set app-level brightness (0.0–1.0) |
| `Stream<double> get onBrightnessChanged` | Broadcast stream of brightness changes |
| `void dispose()` | Release native resources |

## Platform Details

### Android
- Uses `WindowManager.LayoutParams.screenBrightness`
- `onBrightnessChanged` uses `ContentObserver` on `Settings.System.SCREEN_BRIGHTNESS`

### iOS
- Uses `UIScreen.main.brightness`
- `onBrightnessChanged` uses `UIScreen.brightnessDidChangeNotification`

## Development

This project uses [Melos](https://melos.invertase.dev/) to manage the monorepo.

### Setup

```bash
# Install Melos globally
dart pub global activate melos

# Bootstrap all packages (links local deps, resolves pub)
melos bootstrap
```

### Common Commands

```bash
# Run analysis across all packages
melos run analyze

# Run tests across all packages
melos run test

# Run tests with coverage
melos run test:coverage

# Check formatting
melos run format

# Fix formatting
melos run format:fix

# Dry-run publish to check for issues
melos run dry-run
```

### Regenerating native bindings

After modifying native code, regenerate bindings:

```bash
# Build Android first (required for jnigen)
cd packages/display_brightness/example && flutter build apk && cd ../../..

# Generate Android bindings
melos run codegen:android

# Generate iOS bindings (requires Xcode)
melos run codegen:ios
```

### Troubleshooting Android Bindings Generation

If you encounter the following error when running `tool/jnigen.dart`:
```
Unexpected end of input (at character 1)
```
This is likely because the compiled classes parser fails. You can resolve this by rebuilding the Android library with the gradle wrapper directly.

Run the following from the plugin's `packages/display_brightness/example/android` directory:
```bash
./gradlew :display_brightness:assembleDebug --no-daemon --console=plain --refresh-dependencies --rerun-tasks
```

*Special thanks to Dominik Roszkowski for sharing this fix in his article: [jnigen and swiftgen in 2026 - some lessons learned](https://roszkowski.dev/2026/swiftgen-jnigen/#issues-while-regenerating-bindings).*

### Publishing

To publish new versions:
1. Commit all your changes.
2. Run `melos version` locally.
3. Push your commits and tags to GitHub:
   ```bash
   git push && git push --tags
   ```
