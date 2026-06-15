import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:jni/jni.dart';
import 'package:jni_flutter/jni_flutter.dart' as jnif;

import 'display_brightness_controller.dart';
import 'display_brightness_android.g.dart';

/// Android implementation of [DisplayBrightnessController] backed by
/// a JNI [DisplayBrightness] instance.
class DisplayBrightnessAndroid implements DisplayBrightnessController {
  late final DisplayBrightness _native;
  StreamController<double>? _controller;
  BrightnessCallback? _callback;

  /// Creates a [DisplayBrightnessAndroid] using the current Activity
  /// obtained via `jni_flutter`.
  DisplayBrightnessAndroid() {
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
  void setBrightness(double value) {
    _native.brightness$1 = value;
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
    _callback = BrightnessCallback.implement(
      $BrightnessCallback(
        onBrightnessChanged: (brightness) {
          _controller?.add(brightness);
        },
        onBrightnessChanged$async: true,
      ),
    );
    _native.startObserving(_callback!);
  }

  void _stopObserving() {
    _native.stopObserving();
    _callback?.release();
    _callback = null;
  }

  @override
  void dispose() {
    _stopObserving();
    _controller?.close();
    _controller = null;
    _native.release();
  }
}
