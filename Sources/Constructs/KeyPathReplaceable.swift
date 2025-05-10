//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

/// Creates a new copy of the given value type object with a specific property replaced by a new value.
///
/// - Parameters:
///   - keyPath: The key path to the property that should be replaced.
///   - object: The original object to perform the replacement on.
///   - value: The new value to assign at the specified key path.
/// - Returns: A new object with the updated property.
///
public func replacing<T, U>(_ keyPath: WritableKeyPath<T, U>, on object: T, with value: U) -> T {
    var newObject = object
    newObject[keyPath: keyPath] = value
    return newObject
}

/// A protocol that enables creating modified copies of a type by replacing a property using a key path.
///
/// Conforming types can use the `replacing(_:with:)` method to create a new instance
/// with a given property changed, allowing for value-based mutation.
///
public protocol KeyPathReplaceable {

    /// Returns a new instance with the value at the specified key path replaced.
    ///
    /// - Parameters:
    ///   - keyPath: A writable key path identifying the property to replace.
    ///   - value: The new value to assign to the property.
    /// - Returns: A new instance of the conforming type with the updated property.
    func replacing<LeafType>(_ keyPath: WritableKeyPath<Self, LeafType>, with value: LeafType) -> Self
}

public extension KeyPathReplaceable {
    /// Default implementation of the `replacing(_:with:)` method.
    ///
    /// Delegates to the global `replacing(_:on:with:)` function to create the modified copy.
    /// 
    func replacing<LeafType>(_ keyPath: WritableKeyPath<Self, LeafType>, with value: LeafType) -> Self {
        Constructs.replacing(keyPath, on: self, with: value)
    }
}
