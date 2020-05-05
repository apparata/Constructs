//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

import Foundation

public final class NotificationObserver {
    
    public typealias NotificationHandler = ((Notification) -> Void)
    
    public var handler: NotificationHandler?
    
    public init(notificationName: Notification.Name, handler: NotificationHandler? = nil) {
        self.handler = handler
        addObserver(notificationName: notificationName)
    }
    
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
