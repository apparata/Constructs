//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// Example:
///
/// ```
/// /// Auth token will expire after 3 seconds
/// @Expirable(duration: 3) static var authToken: String?
/// ```
@propertyWrapper
public struct Expirable<Value: ExpressibleByNilLiteral> {
    
    public let duration: TimeInterval
    public var expirationDate: Date = Date()
    private var innerValue: Value = nil
    
    public var wrappedValue: Value {
        get { return hasExpired() ? nil : innerValue }
        set {
            self.expirationDate = Date().addingTimeInterval(duration)
            self.innerValue = newValue
        }
    }
    
    public init(duration: TimeInterval) {
        self.duration = duration
    }
    
    private func hasExpired() -> Bool {
        return expirationDate < Date()
    }
}
