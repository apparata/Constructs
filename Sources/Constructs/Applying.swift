//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

import Foundation

/// Applies a closure to an object and returns the object.
///
/// - Parameters:
///   - object: The object to apply the closure to.
///   - actions: A closure that takes the object and performs side effects.
/// - Returns: The same object, allowing inline mutations or configurations.
///
@discardableResult
public func applyTo<T: AnyObject>(object: T, actions: (T) -> Void) -> T {
    actions(object)
    return object
}

/// A protocol indicating that a type can be used with the `applying(_:)` extension method.
///
/// Conforming types can chain mutation operations using `applying(_:)`.
///
public protocol Applicable: AnyObject { }

extension Applicable {

    /// Applies a closure to `self` and returns `self` to enable fluent-style chaining.
    ///
    /// - Parameter actions: A closure that takes `self` and performs mutations or configuration.
    /// - Returns: The same instance of `self`.
    @discardableResult
    public func applying(_ actions: (Self) -> Void) -> Self {
        actions(self)
        return self
    }
}

extension Optional {
    /// Applies a closure to the unwrapped value if it exists, returning the original optional.
    ///
    /// - Parameter action: A closure that takes the unwrapped value.
    /// - Returns: The same optional, unmodified.
    @discardableResult
    public func applying(_ action: (Wrapped) -> Void) -> Wrapped? {
        switch self {
        case .none:
            break
        case .some(let value):
            action(value)
        }
        return self
    }
}

extension NSObject: Applicable { }

