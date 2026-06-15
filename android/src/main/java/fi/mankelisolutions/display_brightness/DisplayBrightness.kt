package fi.mankelisolutions.display_brightness

import android.app.Activity
import android.content.ContentResolver
import android.database.ContentObserver
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import androidx.annotation.Keep

/**
 * Controls app-level screen brightness and monitors system brightness changes.
 *
 * Uses [android.view.WindowManager.LayoutParams.screenBrightness] to control
 * the app window brightness (no permissions required).
 *
 * @param activity the current Activity used to access the window and content resolver.
 */
@Keep
class DisplayBrightness(private val activity: Activity) {

    private val contentResolver: ContentResolver = activity.contentResolver
    private val brightnessUri: Uri =
        Settings.System.getUriFor(Settings.System.SCREEN_BRIGHTNESS)
    private var contentObserver: ContentObserver? = null
    private var callback: BrightnessCallback? = null

    /**
     * Returns the current effective screen brightness (0.0–1.0).
     *
     * If the app has set a custom brightness via [setBrightness], returns that value.
     * Otherwise, reads the system brightness setting and normalizes it from 0–255 to 0.0–1.0.
     * Returns null if the system brightness cannot be read.
     */
    @get:Keep
    val brightness: Double?
        get() {
            val layoutBrightness = activity.window.attributes.screenBrightness
            val raw = if (layoutBrightness < 0) {
                // App hasn't overridden brightness — read system setting
                try {
                    Settings.System.getInt(
                        contentResolver,
                        Settings.System.SCREEN_BRIGHTNESS
                    ) / 255.0
                } catch (e: Settings.SettingNotFoundException) {
                    null
                }
            } else {
                layoutBrightness.toDouble()
            }
            return if (raw != null) Math.round(raw * 100.0) / 100.0 else null
        }

    /**
     * Sets the app-level screen brightness.
     *
     * @param brightness value between 0.0 (darkest) and 1.0 (brightest).
     */
    @Keep
    fun setBrightness(brightness: Double) {
        val layoutParams = activity.window.attributes
        layoutParams.screenBrightness = brightness.toFloat()
        activity.window.attributes = layoutParams
    }

    /**
     * Starts observing system screen brightness changes.
     *
     * The [callback] will be invoked on the main thread whenever the system
     * brightness setting changes, receiving the effective brightness value (0.0–1.0).
     *
     * Only one callback can be active at a time. Calling this method again
     * replaces the previous callback (and re-registers the observer).
     */
    @Keep
    fun startObserving(callback: BrightnessCallback) {
        stopObserving()

        this.callback = callback

        contentObserver = object : ContentObserver(Handler(Looper.getMainLooper())) {
            override fun onChange(selfChange: Boolean) {
                super.onChange(selfChange)
                val systemBrightness = try {
                    Settings.System.getInt(
                        contentResolver,
                        Settings.System.SCREEN_BRIGHTNESS
                    ) / 255.0
                } catch (e: Settings.SettingNotFoundException) {
                    0.5
                }

                // If app currently overrides brightness, clear it to let the system brightness take effect
                val layoutParams = activity.window.attributes
                if (layoutParams.screenBrightness >= 0) {
                    layoutParams.screenBrightness = -1.0f
                    activity.window.attributes = layoutParams
                }

                val roundedBrightness = Math.round(systemBrightness * 100.0) / 100.0
                this@DisplayBrightness.callback?.onBrightnessChanged(roundedBrightness)
            }
        }

        contentResolver.registerContentObserver(brightnessUri, false, contentObserver!!)
    }

    /**
     * Stops observing screen brightness changes and removes the callback.
     */
    @Keep
    fun stopObserving() {
        contentObserver?.let {
            contentResolver.unregisterContentObserver(it)
        }
        contentObserver = null
        callback = null
    }
}
