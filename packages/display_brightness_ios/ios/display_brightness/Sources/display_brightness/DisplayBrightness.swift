import UIKit

/// Callback protocol for screen brightness changes.
@objc public protocol BrightnessCallback {
    /// Called when the screen brightness changes.
    ///
    /// - Parameter brightness: the new brightness value (0.0–1.0).
    @objc func onBrightnessChanged(_ brightness: Double)
}

/// Controls app-level screen brightness and monitors brightness changes.
///
/// Uses `UIScreen.main.brightness` to control and read screen brightness.
/// No permissions are required.
@objc public class DisplayBrightness: NSObject {
    private var observer: NSObjectProtocol?
    private var callback: BrightnessCallback?

    @objc public override init() {
        super.init()
    }

    /// Returns the current screen brightness value (0.0–1.0).
    @objc public var brightness: Double {
        return (Double(UIScreen.main.brightness) * 100.0).rounded() / 100.0
    }

    /// Sets the screen brightness.
    ///
    /// - Parameter brightness: value between 0.0 (darkest) and 1.0 (brightest).
    @objc public func setBrightness(_ brightness: Double) {
        UIScreen.main.brightness = CGFloat(brightness)
    }

    /// Starts observing screen brightness changes.
    ///
    /// The callback will be invoked whenever the screen brightness changes,
    /// receiving the new brightness value (0.0–1.0).
    ///
    /// Only one callback can be active at a time. Calling this method again
    /// replaces the previous callback.
    @objc public func startObserving(callback: BrightnessCallback) {
        stopObserving()

        self.callback = callback

        observer = NotificationCenter.default.addObserver(
            forName: UIScreen.brightnessDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.callback?.onBrightnessChanged(self.brightness)
        }
    }

    /// Stops observing screen brightness changes and removes the callback.
    @objc public func stopObserving() {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
        observer = nil
        callback = nil
    }

    deinit {
        stopObserving()
    }
}
