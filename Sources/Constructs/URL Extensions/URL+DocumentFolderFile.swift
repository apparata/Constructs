//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

extension URL {

    /// The URL of the user's documents directory.
    ///
    /// Uses `FileManager` to locate the `.documentDirectory` within the `.userDomainMask`.
    /// Triggers a runtime crash if the directory cannot be located.
    ///
    public static var documentsFolder: URL {
        do {
            return try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
        } catch {
            fatalError("Can't find documents directory.")
        }
    }

    /// Initializes a file URL pointing to a file in the user's documents directory.
    ///
    /// - Parameter filename: The name of the file to append to the documents directory URL.
    /// 
    public init(fileInDocuments filename: String) {
        self = Self.documentsFolder
            .appendingPathComponent(filename)
    }
}
