//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// A property wrapper that automatically invalidates a value after a specified time interval.
///
/// `@Expirable` allows you to associate a time-to-live duration with a property, such that the
/// property's value is automatically set to `nil` after the specified interval has elapsed.
/// This is useful for implementing time-based caching, token expiration, or session management.
///
/// **Example:**
///
/// ```swift
/// /// Auth token will expire after 3 seconds
/// @Expirable(duration: 3) static var authToken: String?
/// ```
///
@propertyWrapper
public struct Expirable<Value: ExpressibleByNilLiteral> {

    /// The time interval after which the value expires and is set to `nil`.
    public let duration: TimeInterval

    /// The date and time when the current value will expire.
    public var expirationDate: Date = Date()
    
    private var innerValue: Value = nil

    /// The value wrapped by the property wrapper.
    ///
    /// Accessing this returns `nil` if the value has expired.
    /// Setting it resets the expiration timer.
    public var wrappedValue: Value {
        get { return hasExpired() ? nil : innerValue }
        set {
            self.expirationDate = Date().addingTimeInterval(duration)
            self.innerValue = newValue
        }
    }

    /// Creates a new expirable wrapper with the given duration.
    ///
    /// - Parameter duration: The time interval after which the value should expire.
    public init(duration: TimeInterval) {
        self.duration = duration
    }

    private func hasExpired() -> Bool {
        return expirationDate < Date()
    }
}
