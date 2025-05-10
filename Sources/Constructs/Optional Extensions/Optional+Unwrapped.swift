//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

/// An error type representing a failure to unwrap a `nil` optional.
///
/// Used by the `unwrap()` method to signal that the optional value was `nil` and unwrapping failed.
///
public enum UnwrapError: Swift.Error {
    case triedToUnwrapNil
}

public extension Optional {

    /// Unwraps an optional or throws an error if the value is `nil`.
    ///
    /// - Throws: `UnwrapError.triedToUnwrapNil` if the optional is `nil`.
    /// - Returns: The wrapped value if it exists.
    ///
    func unwrap() throws -> Wrapped {
        switch self {
        case .none: throw UnwrapError.triedToUnwrapNil
        case .some(let wrapped): return wrapped
        }
    }
}

/// Ensures that an optional value is not `nil`, or throws a `RequiredError`.
///
/// - Parameter value: The optional value to validate.
/// - Throws: `RequiredError.required` if the value is `nil`.
/// - Returns: The unwrapped value.
///
public func required<T>(_ value: T?) throws -> T {
    try value.unwrap()
}

/// Returns the unwrapped value or a default if the value is `nil`.
///
/// - Parameters:
///   - value: The optional value to unwrap.
///   - default: A fallback value to return if `value` is `nil`.
/// - Returns: The unwrapped value or the provided default.
///
public func required<T>(_ value: T?, `default`: T) -> T {
    guard let value = value else {
        return `default`
    }
    return value
}

/// Ensures that at least one of the provided optional values is non-nil, or throws a `RequiredError`.
///
/// - Parameter values: A variadic list of optional values.
/// - Throws: `RequiredError.required` if all values are `nil`.
public func atLeastOneRequired<T>(_ values: T?...) throws {
    for value in values {
        if value != nil {
            return
        }
    }
    throw UnwrapError.triedToUnwrapNil
}
