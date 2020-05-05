//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS) || os(macOS)

@propertyWrapper
public struct PlatformDependentValue<T> {

    public var wrappedValue: T {
        platformDependentValue
    }
    
    private let platformDependentValue: T
    
    public init(
        iOS: @autoclosure () -> T,
        tvOS: @autoclosure () -> T,
        macOS: @autoclosure () -> T
    ) {
        #if os(iOS)
        platformDependentValue = iOS()
        #elseif os(tvOS)
        platformDependentValue = tvOS()
        #elseif os(macOS)
        platformDependentValue = macOS()
        #endif
    }
}

#endif
