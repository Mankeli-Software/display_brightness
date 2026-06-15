import 'package:flutter_test/flutter_test.dart';
import 'package:display_brightness/display_brightness.dart';
import 'package:display_brightness/src/display_brightness_android.dart';
import 'package:display_brightness/src/display_brightness_ios.dart';

class FakeAndroidDelegate implements AndroidDisplayBrightnessDelegate {
  double? _brightness;
  void Function(double)? _listener;
  bool disposed = false;
  bool isObserving = false;

  @override
  double? get brightness => _brightness;

  @override
  set brightness(double value) {
    _brightness = value;
  }

  @override
  void startObserving(void Function(double) onBrightnessChanged) {
    isObserving = true;
    _listener = onBrightnessChanged;
  }

  @override
  void stopObserving() {
    isObserving = false;
    _listener = null;
  }

  @override
  void dispose() {
    disposed = true;
  }

  void simulateNativeBrightnessChange(double value) {
    _brightness = value;
    _listener?.call(value);
  }
}

class FakeIosDelegate implements IosDisplayBrightnessDelegate {
  double? _brightness;
  void Function(double)? _listener;
  bool isObserving = false;

  @override
  double? get brightness => _brightness;

  @override
  void setBrightness(double value) {
    _brightness = value;
  }

  @override
  void startObserving(void Function(double) onBrightnessChanged) {
    isObserving = true;
    _listener = onBrightnessChanged;
  }

  @override
  void stopObserving() {
    isObserving = false;
    _listener = null;
  }

  void simulateNativeBrightnessChange(double value) {
    _brightness = value;
    _listener?.call(value);
  }
}

void main() {
  group('DisplayBrightnessController Factory', () {
    setUp(() {
      DisplayBrightnessController.isAndroidOverride = false;
      DisplayBrightnessController.isIosOverride = false;
      DisplayBrightnessController.androidDelegateOverride = FakeAndroidDelegate();
      DisplayBrightnessController.iosDelegateOverride = FakeIosDelegate();
    });

    tearDown(() {
      DisplayBrightnessController.androidDelegateOverride = null;
      DisplayBrightnessController.iosDelegateOverride = null;
    });

    test('returns DisplayBrightnessAndroid on Android', () {
      DisplayBrightnessController.isAndroidOverride = true;
      final controller = DisplayBrightnessController();
      expect(controller, isA<DisplayBrightnessAndroid>());
    });

    test('returns DisplayBrightnessIos on iOS', () {
      DisplayBrightnessController.isIosOverride = true;
      final controller = DisplayBrightnessController();
      expect(controller, isA<DisplayBrightnessIos>());
    });

    test('throws UnsupportedError on unsupported platforms', () {
      expect(() => DisplayBrightnessController(), throwsUnsupportedError);
    });
  });

  group('DisplayBrightnessAndroid', () {
    late FakeAndroidDelegate delegate;
    late DisplayBrightnessAndroid controller;

    setUp(() {
      delegate = FakeAndroidDelegate();
      controller = DisplayBrightnessAndroid(delegate: delegate);
    });

    test('gets brightness from delegate', () {
      expect(controller.brightness, isNull);
      delegate.simulateNativeBrightnessChange(0.5);
      expect(controller.brightness, 0.5);
    });

    test('sets brightness on delegate and adds to stream', () async {
      final streamValues = <double>[];
      final sub = controller.onBrightnessChanged.listen(streamValues.add);

      controller.setBrightness(0.75);
      expect(delegate.brightness, 0.75);

      await Future.delayed(Duration.zero);
      expect(streamValues, [0.75]);

      sub.cancel();
    });

    test('sets brightness on delegate without listeners', () {
      controller.setBrightness(0.4);
      expect(delegate.brightness, 0.4);
    });

    test('observes brightness changes from delegate', () async {
      final streamValues = <double>[];
      final sub = controller.onBrightnessChanged.listen(streamValues.add);

      expect(delegate.isObserving, isTrue);

      delegate.simulateNativeBrightnessChange(0.3);
      await Future.delayed(Duration.zero);
      expect(streamValues, [0.3]);

      sub.cancel();
      expect(delegate.isObserving, isFalse);
    });

    test('dispose cleans up native resources', () async {
      final sub = controller.onBrightnessChanged.listen((_) {});
      expect(delegate.isObserving, isTrue);

      controller.dispose();
      expect(delegate.isObserving, isFalse);
      expect(delegate.disposed, isTrue);

      sub.cancel();
    });
  });

  group('DisplayBrightnessIos', () {
    late FakeIosDelegate delegate;
    late DisplayBrightnessIos controller;

    setUp(() {
      delegate = FakeIosDelegate();
      controller = DisplayBrightnessIos(delegate: delegate);
    });

    test('gets brightness from delegate', () {
      expect(controller.brightness, isNull);
      delegate.simulateNativeBrightnessChange(0.6);
      expect(controller.brightness, 0.6);
    });

    test('sets brightness on delegate and adds to stream', () async {
      final streamValues = <double>[];
      final sub = controller.onBrightnessChanged.listen(streamValues.add);

      controller.setBrightness(0.8);
      expect(delegate.brightness, 0.8);

      await Future.delayed(Duration.zero);
      expect(streamValues, [0.8]);
      
      // Duplicates should not be emitted
      controller.setBrightness(0.8);
      await Future.delayed(Duration.zero);
      expect(streamValues, [0.8]); // still 1 item

      sub.cancel();
    });

    test('sets brightness on delegate without listeners', () {
      controller.setBrightness(0.9);
      expect(delegate.brightness, 0.9);
    });

    test('observes brightness changes from delegate', () async {
      final streamValues = <double>[];
      final sub = controller.onBrightnessChanged.listen(streamValues.add);

      expect(delegate.isObserving, isTrue);

      delegate.simulateNativeBrightnessChange(0.2);
      await Future.delayed(Duration.zero);
      expect(streamValues, [0.2]);

      // Duplicates should not be emitted
      delegate.simulateNativeBrightnessChange(0.2);
      await Future.delayed(Duration.zero);
      expect(streamValues, [0.2]);

      delegate.simulateNativeBrightnessChange(0.4);
      await Future.delayed(Duration.zero);
      expect(streamValues, [0.2, 0.4]);

      sub.cancel();
      expect(delegate.isObserving, isFalse);
    });

    test('dispose cleans up resources', () async {
      final sub = controller.onBrightnessChanged.listen((_) {});
      expect(delegate.isObserving, isTrue);

      controller.dispose();
      expect(delegate.isObserving, isFalse);

      sub.cancel();
    });
  });
}
