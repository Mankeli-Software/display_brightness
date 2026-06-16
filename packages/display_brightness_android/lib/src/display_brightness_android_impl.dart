import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:display_brightness_platform_interface/display_brightness_platform_interface.dart';
import 'package:jni/jni.dart';
import 'package:jni_flutter/jni_flutter.dart' as jnif;
import 'package:meta/meta.dart';

import 'display_brightness_android.g.dart';

/// Delegate interface for Android display brightness operations.
///
/// Abstracts native JNI calls to allow dependency injection for testing.
abstract class AndroidDisplayBrightnessDelegate {
  double? get brightness;
  set brightness(double value);
  void startObserving(void Function(double) onBrightnessChanged);
  void stopObserving();
  void dispose();
}

// coverage:ignore-start
class _DefaultAndroidDisplayBrightnessDelegate
    implements AndroidDisplayBrightnessDelegate {
  late final DisplayBrightness _native;
  BrightnessCallback? _callback;

  _DefaultAndroidDisplayBrightnessDelegate() {
    final engineId = PlatformDispatcher.instance.engineId;
    if (engineId == null) {
      throw StateError('Engine ID is null — cannot access Activity');
    }

    final activity = jnif.androidActivity(engineId);
    if (activity == null) {
      throw StateError('Activity is null — cannot access Activity');
    }

    _native = DisplayBrightness(activity);
  }

  @override
  double? get brightness {
    final nativeVal = _native.brightness;
    if (nativeVal == null) return null;
    return nativeVal.toDartDouble(releaseOriginal: true);
  }

  @override
  set brightness(double value) {
    _native.brightness$1 = value;
  }

  @override
  void startObserving(void Function(double) onBrightnessChanged) {
    _callback = BrightnessCallback.implement(
      $BrightnessCallback(
        onBrightnessChanged: onBrightnessChanged,
        onBrightnessChanged$async: true,
      ),
    );
    _native.startObserving(_callback!);
  }

  @override
  void stopObserving() {
    _native.stopObserving();
    _callback?.release();
    _callback = null;
  }

  @override
  void dispose() {
    _native.release();
  }
}
// coverage:ignore-end

/// Android implementation of [DisplayBrightnessPlatform] backed by
/// a JNI [DisplayBrightness] instance.
class DisplayBrightnessAndroid extends DisplayBrightnessPlatform {
  AndroidDisplayBrightnessDelegate? _delegateInstance;
  StreamController<double>? _controller;

  /// Creates a [DisplayBrightnessAndroid] using the current Activity
  /// obtained via `jni_flutter`.
  DisplayBrightnessAndroid({
    @visibleForTesting AndroidDisplayBrightnessDelegate? delegate,
  }) : _delegateInstance = delegate;

  AndroidDisplayBrightnessDelegate get _delegate =>
      _delegateInstance ??= _DefaultAndroidDisplayBrightnessDelegate();

  /// Registers this class as the default instance of
  /// [DisplayBrightnessPlatform].
  static void registerWith() {
    DisplayBrightnessPlatform.instance = DisplayBrightnessAndroid();
  }

  @override
  double? get brightness => _delegate.brightness;

  @override
  void setBrightness(double value) {
    _delegate.brightness = value;
    if (_controller != null && !_controller!.isClosed) {
      _controller!.add(value);
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
      _controller?.add(brightness);
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
    _delegate.dispose();
  }
}
