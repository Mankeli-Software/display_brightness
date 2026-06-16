# display_brightness_platform_interface

A common platform interface for the [`display_brightness`](https://pub.dev/packages/display_brightness) plugin.

This interface allows platform-specific implementations of the `display_brightness` plugin, as well as the plugin itself, to ensure they are supporting the same interface.

## Usage

To implement a new platform-specific implementation of `display_brightness`, extend [`DisplayBrightnessPlatform`](lib/src/display_brightness_platform.dart) with an implementation that performs the platform-specific behavior, and when the plugin is registered, set the default `DisplayBrightnessPlatform.instance` to your implementation.

## Note on breaking changes

Strongly prefer non-breaking changes (such as adding a method to the interface) over breaking changes for this package.

See https://flutter.dev/to/platform-interface-breaking-changes for a discussion on why a less-clean interface is preferable to a breaking change.
