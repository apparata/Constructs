//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

import Foundation

public func applyTo<T>(object: T, actions: (T) -> Void) -> T {
    actions(object)
    return object
}

public protocol Applicable: AnyObject { }

extension Applicable {
    
    @discardableResult
    public func applying(_ actions: (Self) -> Void) -> Self {
        actions(self)
        return self
    }
    
}

extension Optional {
    
    @discardableResult
    public func applying(_ action: (Wrapped) -> Void) -> Optional<Wrapped> {
        switch self {
        case .none:
            break
        case .some(let value):
            action(value)
        }
        return self
    }
}

extension NSObject: Applicable { }

