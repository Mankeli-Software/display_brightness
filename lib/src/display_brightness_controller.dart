import 'dart:async';
import 'dart:io' show Platform;

import 'display_brightness_android.dart';
import 'display_brightness_ios.dart';

/// Controls the app-level screen brightness.
///
/// Creates a platform-specific implementation automatically via the
/// factory constructor. Currently supports Android and iOS.
///
/// Usage:
/// ```dart
/// final brightness = DisplayBrightnessController();
///
/// // Get current brightness (0.0–1.0)
/// print(brightness.brightness);
///
/// // Set brightness
/// brightness.setBrightness(0.8);
///
/// // Listen to changes
/// final sub = brightness.onBrightnessChanged.listen((value) {
///   print('Brightness: $value');
/// });
///
/// // Cleanup
/// sub.cancel();
/// brightness.dispose();
/// ```
abstract class DisplayBrightnessController {
  /// Creates a [DisplayBrightnessController] for the current platform.
  ///
  /// Throws [UnsupportedError] on unsupported platforms.
  factory DisplayBrightnessController() {
    if (Platform.isAndroid) return DisplayBrightnessAndroid();
    if (Platform.isIOS) return DisplayBrightnessIos();
    throw UnsupportedError(
      'DisplayBrightnessController is not supported on this platform.',
    );
  }

  /// Returns the current effective brightness (0.0–1.0), or `null` if the
  /// system brightness setting could not be read (Android only).
  ///
  /// On Android, returns the app-level brightness if set via [setBrightness],
  /// otherwise falls back to the system brightness.
  /// On iOS, returns `UIScreen.main.brightness`.
  double? get brightness;

  /// Sets the app-level brightness.
  ///
  /// [value] must be between 0.0 (darkest) and 1.0 (brightest).
  ///
  /// On Android, this sets `WindowManager.LayoutParams.screenBrightness`
  /// on the current Activity's window. No permissions required.
  /// On iOS, this sets `UIScreen.main.brightness`. No permissions required.
  void setBrightness(double value);

  /// A broadcast stream that emits brightness values (0.0–1.0)
  /// whenever the screen brightness changes.
  ///
  /// On Android, emits when the system brightness setting changes
  /// (via `ContentObserver` on `Settings.System.SCREEN_BRIGHTNESS`).
  /// On iOS, emits on `UIScreen.brightnessDidChangeNotification`.
  ///
  /// The stream starts observing when the first listener subscribes
  /// and stops when all listeners cancel.
  Stream<double> get onBrightnessChanged;

  /// Releases all native resources.
  ///
  /// After calling this, the controller should not be used.
  void dispose();
}
