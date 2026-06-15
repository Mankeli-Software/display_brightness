import 'dart:async';

import 'package:meta/meta.dart';

import 'display_brightness_controller.dart';
import 'display_brightness_ios.g.dart';

abstract class IosDisplayBrightnessDelegate {
  double? get brightness;
  void setBrightness(double value);
  void startObserving(void Function(double) onBrightnessChanged);
  void stopObserving();
}

// coverage:ignore-start
class _DefaultIosDisplayBrightnessDelegate implements IosDisplayBrightnessDelegate {
  late final DisplayBrightness _native;
  BrightnessCallback? _callback;

  _DefaultIosDisplayBrightnessDelegate() {
    _native = DisplayBrightness();
  }

  @override
  double? get brightness => _native.brightness;

  @override
  void setBrightness(double value) {
    _native.setBrightness(value);
  }

  @override
  void startObserving(void Function(double) onBrightnessChanged) {
    _callback = BrightnessCallback$Builder.implementAsListener(
      onBrightnessChanged_: onBrightnessChanged,
    );
    _native.startObservingWithCallback(_callback!);
  }

  @override
  void stopObserving() {
    _native.stopObserving();
    _callback = null;
  }
}
// coverage:ignore-end

/// iOS implementation of [DisplayBrightnessController] backed by a
/// swiftgen-generated [DisplayBrightness] instance.
class DisplayBrightnessIos implements DisplayBrightnessController {
  final IosDisplayBrightnessDelegate _delegate;
  StreamController<double>? _controller;
  double? _lastEmittedValue;

  /// Creates a [DisplayBrightnessIos].
  DisplayBrightnessIos({@visibleForTesting IosDisplayBrightnessDelegate? delegate})
      : _delegate = delegate ?? _DefaultIosDisplayBrightnessDelegate(); // coverage:ignore-line

  @override
  double? get brightness => _delegate.brightness;

  @override
  void setBrightness(double value) {
    _delegate.setBrightness(value);
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
    _delegate.startObserving((brightness) {
      if (_lastEmittedValue != brightness) {
        _lastEmittedValue = brightness;
        _controller?.add(brightness);
      }
    });
  }

  void _stopObserving() {
    _delegate.stopObserving();
  }

  @override
  void dispose() {
    _stopObserving();
    _controller?.close();
    _controller = null;
  }
}
