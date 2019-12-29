//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// Example:
/// 
/// ```
/// @Clamped(initialValue: 0.5, min: 0, max: 1)
/// var whatever: Double
/// ```
@propertyWrapper
public struct Clamped<Value: Comparable> {
    public var value: Value
    public let min: Value
    public let max: Value
    
    public init(initialValue: Value, min: Value, max: Value) {
        value = initialValue
        self.min = min
        self.max = max
        assert(value >= min && value <= max)
    }
    
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
