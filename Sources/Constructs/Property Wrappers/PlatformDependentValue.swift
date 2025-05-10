//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS) || os(macOS) || os(visionOS)

/// A property wrapper that provides a value depending on the current Apple platform.
///
/// Use this to specify different values for iOS, tvOS, macOS, and visionOS at runtime.
/// The correct value is selected during initialization based on the current compilation target.
///
@propertyWrapper
public struct PlatformDependentValue<T> {

    /// The platform-specific value provided by the property wrapper.
    ///
    /// Returns the value associated with the current platform.
    ///
    public var wrappedValue: T {
        platformDependentValue
    }

    private let platformDependentValue: T

    /// Initializes the wrapper with values for each supported Apple platform.
    ///
    /// - Parameters:
    ///   - iOS: The value to use on iOS.
    ///   - tvOS: The value to use on tvOS.
    ///   - macOS: The value to use on macOS.
    ///   - visionOS: The value to use on visionOS.
    ///
    /// The appropriate value is selected based on the platform being compiled.
    ///
    public init(
        iOS: @autoclosure () -> T,
        tvOS: @autoclosure () -> T,
        macOS: @autoclosure () -> T,
        visionOS: @autoclosure () -> T
    ) {
        #if os(iOS)
        platformDependentValue = iOS()
        #elseif os(tvOS)
        platformDependentValue = tvOS()
        #elseif os(macOS)
        platformDependentValue = macOS()
        #elseif os(visionOS)
        platformDependentValue = visionOS()
        #endif
    }
}

#endif
