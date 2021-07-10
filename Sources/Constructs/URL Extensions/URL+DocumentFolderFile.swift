//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

extension URL {

    static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }

    init(fileInDocuments filename: String) {
        self = Self.documentsFolder
            .appendingPathComponent(filename)
    }
}
