//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

import Foundation

public class Subscribers<Subscriber> {

    /// The entry class keeps a weak reference to the subscriber,
    /// so that it subscribers don't have to unsubscribe manually.
    private class SubscriberEntry {
        private weak var weakSubscriber: AnyObject?
        
        var subscriber: Subscriber? {
            return weakSubscriber as? Subscriber
        }

        init(subscriber: Subscriber) {
            weakSubscriber = subscriber as AnyObject
        }
    }

    private var subscribers: [ObjectIdentifier: SubscriberEntry] = [:]

    private var queue: DispatchQueue?

    public init(queue: DispatchQueue? = nil) {
        self.queue = queue
    }

    public func add(_ subscriber: Subscriber) {
        removeStaleEntries()
        let key = ObjectIdentifier(subscriber as AnyObject)
        if subscribers[key] != nil {
            return
        }
        subscribers[key] = SubscriberEntry(subscriber: subscriber)
    }

    /// Remove a subscriber from the list of subscribers.
    /// (Subscribers are also implicitly removed if they are deallocated.)
    public func remove(_ subscriber: Subscriber) {
        removeStaleEntries()
        let key = ObjectIdentifier(subscriber as AnyObject)
        subscribers.removeValue(forKey: key)
    }

    /// Invokes closure on all subscribers
    public func invoke(_ invocation: @escaping (Subscriber) -> Void) {
        removeStaleEntries()
        for (_, entry) in subscribers {
            guard let subscriber = entry.subscriber else {
                continue
            }
            if let queue = queue {
                queue.async {
                    invocation(subscriber)
                }
            } else {
                invocation(subscriber)
            }
        }
    }

    /// Remove entries for subscribers that have been deallocated.
    private func removeStaleEntries() {
        for (key, entry) in subscribers {
            if entry.subscriber == nil {
                subscribers.removeValue(forKey: key)
            }
        }
    }
}
