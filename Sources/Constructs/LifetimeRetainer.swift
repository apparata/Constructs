//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

import Foundation

public protocol LifetimeRetainable: AnyObject {
    func retainedBy(_ retainer: LifetimeRetainer) -> Self
}

extension LifetimeRetainable {
    // Default implementation
    func retainedBy(_ retainer: LifetimeRetainer) -> Self {
        retainer.retain(self)
        return self
    }
}

/// Retains objects for the lifetime of the retainer object.
///
/// Example:
/// ```swift
/// class Fruit: LifetimeRetainable {
///     let isBanana: Bool
///
///     init() {
///         isBanana = true
///     }
/// }
///
/// let retainer = LifetimeRetainer()
///
/// let fruit: Fruit = Fruit().retainedBy(retainer)
/// ```
public final class LifetimeRetainer {
    
    private var retainedObjects: [LifetimeRetainable] = []
    
    public func retain(_ retainable: LifetimeRetainable) {
        retainedObjects.append(retainable)
    }
}
