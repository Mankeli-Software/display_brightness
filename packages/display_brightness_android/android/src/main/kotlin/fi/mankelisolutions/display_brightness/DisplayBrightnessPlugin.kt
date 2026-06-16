package fi.mankelisolutions.display_brightness

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * A dummy FlutterPlugin implementation.
 * 
 * Since this is an FFI plugin, we don't actually need MethodChannels.
 * However, we provide this pluginClass so that Flutter's build tools
 * automatically enable "built-in Kotlin" support and inject the
 * Kotlin Gradle Plugin correctly for AGP 9.0+.
 */
class DisplayBrightnessPlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var channel : MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "display_brightness_dummy")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        result.notImplemented()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
