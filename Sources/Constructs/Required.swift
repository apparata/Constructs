//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

import Foundation

enum RequiredError: Error {
    case required
}

func required<T>(_ value: T?) throws -> T {
    guard let value = value else {
        throw RequiredError.required
    }
    return value
}

func required<T>(_ value: T?, `default`: T) -> T {
    guard let value = value else {
        return `default`
    }
    return value
}

func atLeastOneRequired<T>(_ values: T?...) throws {
    for value in values {
        if value != nil {
            return
        }
    }
    throw RequiredError.required
}
