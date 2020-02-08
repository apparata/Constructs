//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

public func replacing<T, U>(_ keyPath: WritableKeyPath<T, U>, on object: T, with value: U) -> T {
    var newObject = object
    newObject[keyPath: keyPath] = value
    return newObject
}

public protocol KeyPathReplaceable {
    
    /// Example:
    ///
    /// ```
    /// struct User: KeyPathReplaceable {
    ///     var name: String
    ///     var email: String
    /// }
    ///
    /// let user = User(name: "Luke", email: "luke@mailinator.com")
    /// let updatedUser = user.replacing(\.email, with: "luke1337@mailinator.com")
    /// ```
    func replacing<LeafType>(_ keyPath: WritableKeyPath<Self, LeafType>, with value: LeafType) -> Self
}

public extension KeyPathReplaceable {
    func replacing<LeafType>(_ keyPath: WritableKeyPath<Self, LeafType>, with value: LeafType) -> Self {
        Constructs.replacing(keyPath, on: self, with: value)
    }
}
