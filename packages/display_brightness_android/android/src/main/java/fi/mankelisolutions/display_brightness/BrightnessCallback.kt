package fi.mankelisolutions.display_brightness

import androidx.annotation.Keep

/**
 * Callback interface for screen brightness changes.
 *
 * Implement this interface to receive notifications when the system screen
 * brightness setting changes.
 */
@Keep
interface BrightnessCallback {
    /**
     * Called when the screen brightness changes.
     *
     * @param brightness the new brightness value (0.0–1.0).
     */
    @Keep
    fun onBrightnessChanged(brightness: Double)
}
