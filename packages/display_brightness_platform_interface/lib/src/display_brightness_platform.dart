import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of display_brightness must implement.
///
/// Platform implementations should extend this class rather than implement it,
/// as `implement` does not consider newly added methods to be breaking changes.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
/// this interface will be broken by newly added [DisplayBrightnessPlatform]
/// methods.
abstract class DisplayBrightnessPlatform extends PlatformInterface {
  /// Constructs a [DisplayBrightnessPlatform].
  DisplayBrightnessPlatform() : super(token: _token);

  static final Object _token = Object();

  static DisplayBrightnessPlatform? _instance;

  /// The instance of [DisplayBrightnessPlatform] to use.
  ///
  /// Platform-specific plugins should set this to their own platform-specific
  /// class that extends [DisplayBrightnessPlatform] when they register
  /// themselves.
  static DisplayBrightnessPlatform get instance {
    final instance = _instance;
    if (instance == null) {
      throw StateError(
        'DisplayBrightnessPlatform has not been set. '
        'Make sure to include a platform implementation package '
        '(e.g. display_brightness_android, display_brightness_ios).',
      );
    }
    return instance;
  }

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [DisplayBrightnessPlatform] when they register
  /// themselves.
  static set instance(DisplayBrightnessPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Returns the current effective brightness (0.0–1.0), or `null` if the
  /// system brightness setting could not be read.
  ///
  /// On Android, returns the app-level brightness if set via [setBrightness],
  /// otherwise falls back to the system brightness.
  /// On iOS, returns `UIScreen.main.brightness`.
  double? get brightness {
    throw UnimplementedError('brightness has not been implemented.');
  }

  /// Sets the app-level brightness.
  ///
  /// [value] must be between 0.0 (darkest) and 1.0 (brightest).
  ///
  /// On Android, this sets `WindowManager.LayoutParams.screenBrightness`
  /// on the current Activity's window. No permissions required.
  /// On iOS, this sets `UIScreen.main.brightness`. No permissions required.
  void setBrightness(double value) {
    throw UnimplementedError('setBrightness() has not been implemented.');
  }

  /// A broadcast stream that emits brightness values (0.0–1.0)
  /// whenever the screen brightness changes.
  ///
  /// On Android, emits when the system brightness setting changes
  /// (via `ContentObserver` on `Settings.System.SCREEN_BRIGHTNESS`).
  /// On iOS, emits on `UIScreen.brightnessDidChangeNotification`.
  ///
  /// The stream starts observing when the first listener subscribes
  /// and stops when all listeners cancel.
  Stream<double> get onBrightnessChanged {
    throw UnimplementedError('onBrightnessChanged has not been implemented.');
  }

  /// Releases all native resources.
  ///
  /// After calling this, the platform instance should not be used.
  void dispose() {
    throw UnimplementedError('dispose() has not been implemented.');
  }
}
