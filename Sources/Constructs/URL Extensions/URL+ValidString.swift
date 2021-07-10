//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension URL {
    init(validString: String) {
        // swiftlint:disable force_unwrapping
        self.init(string: validString.description)!
        // swiftlint:enable force_unwrapping
    }
}
