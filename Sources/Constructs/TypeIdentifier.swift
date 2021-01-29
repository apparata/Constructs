//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

/// An indentifiable, hashable, and equatable wrapper for metatypes.
///
/// Example:
///
/// ```
/// var valueByType: [TypeIdentifer: Any] = [:]
/// valueByType[String.self] = "This is a string"
/// valueByType[Int.self] = 1337
/// ```
public struct TypeIdentifier: Identifiable, Hashable {

    public var id: ObjectIdentifier {
        ObjectIdentifier(type)
    }
    
    private let type: Any.Type
    
    public init(_ type: Any.Type) {
        self.type = type
    }

    public func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    public static func == (lhs: TypeIdentifier, rhs: TypeIdentifier) -> Bool {
        return lhs.type == rhs.type
    }
}
