import 'dart:async';

import 'display_brightness_controller.dart';
import 'display_brightness_ios.g.dart';

/// iOS implementation of [DisplayBrightnessController] backed by a
/// swiftgen-generated [DisplayBrightness] instance.
class DisplayBrightnessIos implements DisplayBrightnessController {
  late final DisplayBrightness _native;
  StreamController<double>? _controller;
  BrightnessCallback? _callback;
  double? _lastEmittedValue;

  /// Creates a [DisplayBrightnessIos].
  DisplayBrightnessIos() {
    _native = DisplayBrightness();
  }

  @override
  double? get brightness => _native.brightness;

  @override
  void setBrightness(double value) {
    _native.setBrightness(value);
    if (_lastEmittedValue != value) {
      _lastEmittedValue = value;
      if (_controller != null && !_controller!.isClosed) {
        _controller!.add(value);
      }
    }
  }

  @override
  Stream<double> get onBrightnessChanged {
    _controller ??= StreamController<double>.broadcast(
      onListen: _startObserving,
      onCancel: _stopObserving,
    );
    return _controller!.stream;
  }

  void _startObserving() {
    _callback = BrightnessCallback$Builder.implementAsListener(
      onBrightnessChanged_: (brightness) {
        if (_lastEmittedValue != brightness) {
          _lastEmittedValue = brightness;
          _controller?.add(brightness);
        }
      },
    );
    _native.startObservingWithCallback(_callback!);
  }

  void _stopObserving() {
    _native.stopObserving();
    _callback = null;
  }

  @override
  void dispose() {
    _stopObserving();
    _controller?.close();
    _controller = null;
  }
}
