//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

import Foundation

/// A wrapper that holds a weak reference to an object of type `T`.
///
/// Useful for storing weak references in collections such as arrays, where you
/// want to avoid creating strong reference cycles or retain objects beyond their lifecycle.
///
public class WeakBox<T: AnyObject> {

    public private(set) weak var value: T?

    public init(_ value: T) {
        self.value = value
    }
}
