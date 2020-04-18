//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

public class HashableType: Hashable {

    private var type: Any.Type

    public init(_ type: Any.Type) {
        self.type = type
    }

    public func hash(into hasher: inout Hasher) {
      hasher.combine(ObjectIdentifier(type))
    }

    public static func == (lhs: HashableType, rhs: HashableType) -> Bool {
        return lhs.type == rhs.type
    }
}

public extension Dictionary where Key == HashableType, Value == Any {
    subscript<T>(key: T.Type) -> T? {
        get {
            return self[HashableType(key)] as? T
        }
        set { self[HashableType(key)] = newValue }
    }
}
