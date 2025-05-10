//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// Example:
///
/// ```
/// @Atomic(value: 0) var someValue
/// $someValue.mutate { $0 += 1 }
/// $someValue.set { 7 }
/// ```
@available(*, deprecated, message: "Atomic is deprecated. Use Atomic from Apple's Synchronization framework instead.")
@propertyWrapper
public class Atomic<Value> {
    
    private var value: Value

    private let lock = NSLock()
    
    public var wrappedValue: Value {
        lock.lock()
        defer {
            lock.unlock()
        }
        return value
    }
    
    public var projectedValue: Atomic<Value> {
        return self
    }
    
    public func mutate(_ transform: (inout Value) -> Void) {
        defer { lock.unlock() }
        lock.lock()
        transform(&value)
    }
    
    @discardableResult
    public func set(_ transform: () -> Value) -> Value {
        defer { lock.unlock() }
        lock.lock()
        value = transform()
        return value
    }
    
    public init(value: Value) {
        self.value = value
    }
}
