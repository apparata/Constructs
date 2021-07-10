//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

extension URL {

    var fileExists: Bool {
        return isFileURL && FileManager.default.fileExists(atPath: path)
    }
}
