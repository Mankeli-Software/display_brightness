import 'dart:io';

import 'package:jnigen/jnigen.dart';

void main(List<String> args) {
  final packageRoot = Platform.script.resolve('../');
  generateJniBindings(
    Config(
      outputConfig: OutputConfig(
        dartConfig: DartCodeOutputConfig(
          path: packageRoot.resolve(
            'lib/src/display_brightness_android.g.dart',
          ),
          structure: OutputStructure.singleFile,
        ),
      ),
      androidSdkConfig: AndroidSdkConfig(
        addGradleDeps: true,
        androidExample: '../../packages/display_brightness/example',
      ),
      classPath: [
        packageRoot.resolve(
          '../../packages/display_brightness/example/build/display_brightness_android/tmp/kotlin-classes/release/',
        ),
      ],
      classes: [
        'fi.mankelisolutions.display_brightness.BrightnessCallback',
        'fi.mankelisolutions.display_brightness.DisplayBrightness',
      ],
    ),
  );
}
