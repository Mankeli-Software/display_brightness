import 'package:flutter_test/flutter_test.dart';
import 'package:display_brightness_android/display_brightness_android.dart';

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

void main() {
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
}
