//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

public enum UnwrapError: Swift.Error {
    case triedToUnwrapNil
}

public extension Optional {
    
    func unwrap() throws -> Wrapped {
        switch self {
        case .none: throw UnwrapError.triedToUnwrapNil
        case .some(let wrapped): return wrapped
        }
    }
}
