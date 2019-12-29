//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

import Foundation

/// Container for a lazily instantiated value. The instatiator closure will
/// not be run until the value property is read. Thread safe.
public final class Lazy<T> {
    
    /// The contained, lazily instantiated value. The instantiater closure
    /// will not be run until this property is read. Thread safe.
    public private(set) lazy var value: T = {
        defer {
            objc_sync_exit(self)
        }
        objc_sync_enter(self)
        isInstantiated = true
        return instantiator()
    }()
    
    /// True if the value has been instantiated.
    public private(set) var isInstantiated: Bool
    
    private let instantiator: () -> T

    /// The instatiator closure will not be run until the value property
    /// is read.
    public init(instantiator: @escaping () -> T) {
        isInstantiated = false
        self.instantiator = instantiator
    }
}
