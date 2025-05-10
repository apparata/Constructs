//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// A property wrapper that clamps a value between a minimum and maximum bound.
///
/// Use `@Clamped` to ensure a property's value stays within a specified range.
/// When the value is set, it is automatically adjusted to fall within the `min` and `max` limits.
///
/// **Example:**
///
/// ```swift
/// @Clamped(initialValue: 0.5, min: 0, max: 1)
/// var whatever: Double
/// ```
@propertyWrapper
public struct Clamped<Value: Comparable> {
    public var value: Value
    public let min: Value
    public let max: Value

    /// Initializes the clamped property wrapper with an initial value and bounds.
    ///
    /// - Parameters:
    ///   - initialValue: The initial value to assign.
    ///   - min: The minimum allowed value.
    ///   - max: The maximum allowed value.
    /// - Precondition: `initialValue` must be between `min` and `max`.
    public init(initialValue: Value, min: Value, max: Value) {
        value = initialValue
        self.min = min
        self.max = max
        assert(value >= min && value <= max)
    }

    /// The clamped value. Setting this property automatically enforces the bounds.
    ///
    /// If the new value is less than `min`, it will be set to `min`.
    /// If it's greater than `max`, it will be set to `max`.
    /// Otherwise, it will be set directly.
    public var wrappedValue: Value {
        get { return value }
        set {
            if newValue < min {
                value = min
            } else if newValue > max {
                value = max
            } else {
                value = newValue
            }
        }
    }
}
