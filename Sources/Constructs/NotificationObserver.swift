//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

import Foundation

/// A utility class that observes specified `Notification.Name`s and invokes a handler when notified.
///
/// Use this class to easily handle notifications using closures instead of selector-based callbacks.
/// Automatically removes itself as an observer upon deinitialization.
///
public final class NotificationObserver {

    /// A closure that handles a received `Notification`.
    public typealias NotificationHandler = ((Notification) -> Void)

    /// The closure that will be called when a matching notification is observed.
    public var handler: NotificationHandler?

    /// Creates an observer for a single notification name.
    ///
    /// - Parameters:
    ///   - notificationName: The name of the notification to observe.
    ///   - handler: A closure to handle the notification when observed.
    public init(notificationName: Notification.Name, handler: NotificationHandler? = nil) {
        self.handler = handler
        addObserver(notificationName: notificationName)
    }

    /// Creates an observer for multiple notification names.
    ///
    /// - Parameters:
    ///   - notificationNames: A list of notification names to observe.
    ///   - handler: A closure to handle the notifications when observed.
    ///   
    public init(notificationNames: [Notification.Name], handler: NotificationHandler? = nil) {
        self.handler = handler
        for notificationName in notificationNames {
            addObserver(notificationName: notificationName)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func addObserver(notificationName: Notification.Name) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(NotificationObserver.notificationObserved(_:)), name: notificationName, object: nil)
    }

    @objc
    private func notificationObserved(_ notification: Notification) {
        handler?(notification)
    }
}
