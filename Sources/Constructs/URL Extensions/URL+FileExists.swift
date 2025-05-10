//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

extension URL {

    /// Indicates whether the URL is a file URL and if the file at the path indicated by the URL exists.
    public var fileExists: Bool {
        return isFileURL && FileManager.default.fileExists(atPath: path)
    }
}
