//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import Foundation

/// A protocol that defines the ability for a reference type to create a snapshot of itself.
///
/// Conforming types implement the `snapshot()` method to return a new instance
/// that represents the current state of the object. This can be used for value-based
/// comparisons, undo functionality, state preservation, or debugging purposes.
///
/// **Example:**
///
/// ```swift
/// class UserProfile {
///     var name: String
///
///     /// Must be `required` for `Self(name: name)`
///     /// to work in `makeSnapshot()`
///     required init(name: String) {
///         self.name = name
///     }
/// }
///
/// extension UserProfile: Snapshottable {
///     func makeSnapshot() -> Self {
///         Self(name: name)
///     }
/// }
/// ```
///
public protocol Snapshottable {

    /// Returns a snapshot representing the current state of the object.
    ///
    /// - Returns: A new instance of `Self` capturing the current state.
    ///
    func makeSnapshot() -> Self
}
