import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:display_brightness_platform_interface/display_brightness_platform_interface.dart';
import 'package:display_brightness/display_brightness.dart';

class MockDisplayBrightnessPlatform extends DisplayBrightnessPlatform
    with MockPlatformInterfaceMixin {
  double? _brightness;
  final _values = <double>[];
  bool disposed = false;

  @override
  double? get brightness => _brightness;

  @override
  void setBrightness(double value) {
    _brightness = value;
    _values.add(value);
  }

  @override
  Stream<double> get onBrightnessChanged => Stream.fromIterable(_values);

  @override
  void dispose() {
    disposed = true;
  }
}

void main() {
  late MockDisplayBrightnessPlatform mockPlatform;
  late DisplayBrightnessController controller;

  setUp(() {
    mockPlatform = MockDisplayBrightnessPlatform();
    DisplayBrightnessPlatform.instance = mockPlatform;
    controller = DisplayBrightnessController();
  });

  group('DisplayBrightnessController', () {
    test('brightness delegates to platform', () {
      expect(controller.brightness, isNull);
      mockPlatform._brightness = 0.7;
      expect(controller.brightness, 0.7);
    });

    test('setBrightness delegates to platform', () {
      controller.setBrightness(0.5);
      expect(mockPlatform.brightness, 0.5);
    });

    test('onBrightnessChanged delegates to platform', () async {
      mockPlatform._brightness = 0.3;
      controller.setBrightness(0.3);
      controller.setBrightness(0.6);

      final values = await controller.onBrightnessChanged.toList();
      expect(values, [0.3, 0.6]);
    });

    test('dispose delegates to platform', () {
      controller.dispose();
      expect(mockPlatform.disposed, isTrue);
    });
  });
}
