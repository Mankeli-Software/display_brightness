# display_brightness

A Flutter plugin for controlling app-level screen brightness on iOS and Android using direct native interop via **jnigen** (Android) and **swiftgen** (iOS). No permissions required.

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

### Regenerating bindings

After modifying native code, regenerate bindings:

```bash
# Build Android first
cd example && flutter build apk && cd ..

# Generate Android bindings
dart run tool/jnigen.dart

# Generate iOS bindings (requires Xcode)
dart run tool/swiftgen.dart
```

### Troubleshooting Android Bindings Generation

If you encounter the following error when running `tool/jnigen.dart`:
```
Unexpected end of input (at character 1)
```
This is likely because the compiled classes parser fails. You can resolve this by rebuilding the Android library with the gradle wrapper directly.

Run the following from the plugin's `example/android` directory:
```bash
./gradlew :display_brightness:assembleDebug --no-daemon --console=plain --refresh-dependencies --rerun-tasks
```

*Special thanks to Dominik Roszkowski for sharing this fix in his article: [jnigen and swiftgen in 2026 - some lessons learned](https://roszkowski.dev/2026/swiftgen-jnigen/#issues-while-regenerating-bindings).*


