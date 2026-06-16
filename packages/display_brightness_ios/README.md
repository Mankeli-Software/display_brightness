# display_brightness_ios

The iOS implementation of [`display_brightness`](https://pub.dev/packages/display_brightness).

## Usage

This package is [endorsed](https://flutter.dev/to/endorsed-federated-plugin), which means you can simply use `display_brightness` normally. This package will be automatically included in your app when you do, so you do not need to add it to your `pubspec.yaml`.

However, if you `import` this package to use any of its APIs directly, you should add it to your `pubspec.yaml` as usual.

## Implementation Details

- Uses `UIScreen.main.brightness` for getting and setting brightness
- Uses `UIScreen.brightnessDidChangeNotification` for change observation
- Native bindings generated via [swiftgen](https://pub.dev/packages/swiftgen) (direct FFI, no method channels)
- No permissions required
