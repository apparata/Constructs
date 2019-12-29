//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

import Foundation

/// Conforming classes are automatically hashable and equatable.
public protocol AutomaticallyHashable: AnyObject, Hashable {}

extension AutomaticallyHashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

