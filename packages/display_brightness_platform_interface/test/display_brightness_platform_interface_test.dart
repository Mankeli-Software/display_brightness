import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:display_brightness_platform_interface/display_brightness_platform_interface.dart';

class _MockDisplayBrightnessPlatform extends DisplayBrightnessPlatform {
  double? _brightness = 0.5;

  @override
  double? get brightness => _brightness;

  @override
  void setBrightness(double value) {
    _brightness = value;
  }

  @override
  Stream<double> get onBrightnessChanged => const Stream.empty();

  @override
  void dispose() {}
}

class _IllegalImplementation extends DisplayBrightnessPlatform
    with MockPlatformInterfaceMixin {}

void main() {
  group('DisplayBrightnessPlatform', () {
    test('instance throws StateError when not set', () {
      expect(() => DisplayBrightnessPlatform.instance, throwsStateError);
    });

    test('can set a mock implementation', () {
      final mock = _MockDisplayBrightnessPlatform();
      DisplayBrightnessPlatform.instance = mock;
      expect(DisplayBrightnessPlatform.instance, mock);
    });

    test('mock implementation returns expected values', () {
      final mock = _MockDisplayBrightnessPlatform();
      DisplayBrightnessPlatform.instance = mock;

      expect(DisplayBrightnessPlatform.instance.brightness, 0.5);
      DisplayBrightnessPlatform.instance.setBrightness(0.8);
      expect(DisplayBrightnessPlatform.instance.brightness, 0.8);
    });

    test('default brightness throws UnimplementedError', () {
      final impl = _IllegalImplementation();
      DisplayBrightnessPlatform.instance = impl;

      expect(
        () => DisplayBrightnessPlatform.instance.brightness,
        throwsUnimplementedError,
      );
    });

    test('default setBrightness throws UnimplementedError', () {
      final impl = _IllegalImplementation();
      DisplayBrightnessPlatform.instance = impl;

      expect(
        () => DisplayBrightnessPlatform.instance.setBrightness(0.5),
        throwsUnimplementedError,
      );
    });

    test('default onBrightnessChanged throws UnimplementedError', () {
      final impl = _IllegalImplementation();
      DisplayBrightnessPlatform.instance = impl;

      expect(
        () => DisplayBrightnessPlatform.instance.onBrightnessChanged,
        throwsUnimplementedError,
      );
    });

    test('default dispose throws UnimplementedError', () {
      final impl = _IllegalImplementation();
      DisplayBrightnessPlatform.instance = impl;

      expect(
        () => DisplayBrightnessPlatform.instance.dispose(),
        throwsUnimplementedError,
      );
    });
  });
}
