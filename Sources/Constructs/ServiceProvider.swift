//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

import Foundation

/// ServiceProviderError is thrown by the ServiceProvider class.
public enum ServiceProviderError: Error {
    /// There is no service registered for the type / qualifier.
    case noSuchService
}

/// Example:
///
/// ```
/// @RequiredService var myService: MyService
/// @RequiredService(qualifier: "Service7") var myService7: MyService
/// ```
@propertyWrapper
public struct RequiredService<ServiceType> {
    
    private var qualifier: ServiceProvider.Qualifier?
    
    public init() {}
    
    public init(qualifier: ServiceProvider.Qualifier) {
        self.qualifier = qualifier
    }
    
    public var wrappedValue: ServiceType {
        if let qualifier = qualifier {
            return ServiceProvider.requiredService(qualifier: qualifier)
        } else {
            return ServiceProvider.requiredService()
        }
    }
}

/// ServiceProvider implements the Service Locator pattern. It is somewhere
/// in the dependency spectrum in between Singleton and Dependency Injection.
public final class ServiceProvider {
    
    // MARK: - Types
    
    /// Service qualifier (string) used to separate services with same type.
    public typealias Qualifier = String
    
    fileprivate typealias Factory = (Qualifier?) -> Any
    
    fileprivate struct Identifier : Hashable {
        fileprivate let type: Any.Type
        fileprivate let qualifier: Qualifier?
        
        fileprivate func hash(into hasher: inout Hasher) {
            if let qualifier = qualifier {
                hasher.combine("\(type) \(String(describing: qualifier))")
            } else {
                hasher.combine("\(type)")
            }
        }
    }
    
    private static var factories = [Identifier: Factory]()
    
    // MARK: - Services
    
    /// Obtain a registered service of a specific protocol type.
    ///
    /// ```
    /// let storageManager: StorageManager = try ServiceProvider.service()
    /// ```
    ///
    /// - throws: `ServiceProviderError.NoSuchService` if there is no matching
    ///     registered service.
    ///
    /// - returns: Service of protocol type T.
    ///
    public static func service<T>() throws -> T! {
        let identifier = Identifier(type: T.self, qualifier: nil)
        guard let factory = factories[identifier],
            let service = factory(nil) as? T else {
                throw ServiceProviderError.noSuchService
        }
        return service
    }
    
    /// Obtain a registered service of a specific protocol type, with a
    /// qualifier to differentiate between services of the same type.
    ///
    /// ```
    /// let storageManager: StorageManager = try ServiceProvider.service()
    /// let fileStorageManager: StorageManager = try ServiceProvider.service(qualifier: "file")
    /// ```
    ///
    /// - parameter qualifier:
    ///     Qualifier to differentiate this service from other services of the
    ///     same type. The qualifier must be a type that is raw representable
    ///     as string, e.g. an enum with a string raw value type.
    ///
    /// - throws: `ServiceProviderError.NoSuchService` if there is no matching
    ///     registered service.
    ///
    /// - returns: Service of protocol type T.
    ///
    public static func service<T>(qualifier: Qualifier) throws -> T! {
        let identifier = Identifier(type: T.self, qualifier: qualifier)
        guard let factory = factories[identifier],
            let service = factory(qualifier) as? T else {
                throw ServiceProviderError.noSuchService
        }
        return service
    }
    
    /// Obtain a registered **required** service of a specific protocol type.
    /// Required means that it's a fatal error, if the service does not exist.
    /// Only use this method for services that are guaranteed to be there.
    ///
    /// ```
    /// let storageManager: StorageManager = ServiceProvider.requiredService()
    /// ```
    ///
    /// - throws: `ServiceProviderError.NoSuchService` if there is no matching
    ///     registered service.
    ///
    /// - returns: Service of protocol type `T`.
    ///
    public static func requiredService<T>() -> T! {
        let identifier = Identifier(type: T.self, qualifier: nil)
        guard let factory = factories[identifier],
            let service = factory(nil) as? T else {
                fatalError("ServiceProvider: There is no required service of \(T.self) type")
        }
        return service
    }
    
    /// Obtain a registered **required** service of a specific protocol type,
    /// with a qualifier to differentiate between services of the same type.
    /// Required means that it's a fatal error if the service does not exist.
    /// Only use this method for services that are guaranteed to be there.
    ///
    /// ```
    /// let storageManager: StorageManager = ServiceProvider.requiredService()
    /// let fileStorageManager: StorageManager = ServiceProvider.requiredService(qualifier: "file")
    /// ```
    ///
    /// - parameter qualifier:
    ///     Qualifier to differentiate this service from other services of the
    ///     same type. The qualifier must be a type that is raw representable
    ///     as string, e.g. an enum with a string raw value type.
    ///
    /// - returns: Service of protocol type `T`.
    ///
    public static func requiredService<T>(qualifier: Qualifier) -> T! {
        let identifier = Identifier(type: T.self, qualifier: qualifier)
        guard let factory = factories[identifier],
            let service = factory(qualifier) as? T else {
                fatalError("ServiceProvider: There is no required service of \(T.self) type, with qualifier \(String(describing: qualifier))")
        }
        return service
    }
    
    /// Obtain a registered **optional** service of a specific protocol type.
    /// Returns `nil` if the service does not exist.
    ///
    /// ```
    /// let storageManager: StorageManager? = ServiceProvider.optionalService()
    /// ```
    ///
    /// - returns: Service of protocol type `T` or `nil`
    ///
    public static func optionalService<T>() -> T? {
        let identifier = Identifier(type: T.self, qualifier: nil)
        guard let factory = factories[identifier],
            let service = factory(nil) as? T else {
            return nil
        }
        return service
    }
    
    /// Obtain a registered **optional** service of a specific protocol type,
    /// with a qualifier to differentiate between services of the same type.
    /// Optional means that `nil` is returned if the service does not exist.
    ///
    /// ```
    /// let storageManager: StorageManager = ServiceProvider.requiredService()
    /// let fileStorageManager: StorageManager = ServiceProvider.requiredService(qualifier: "file")
    /// ```
    ///
    /// - parameter qualifier:
    ///     Qualifier to differentiate this service from other services of the
    ///     same type. The qualifier must be a type that is raw representable
    ///     as string, e.g. an enum with a string raw value type.
    ///
    /// - returns: Service of protocol type `T`.
    ///
    public static func optionalService<T>(qualifier: Qualifier) -> T! {
        let identifier = Identifier(type: T.self, qualifier: qualifier)
        guard let factory = factories[identifier],
            let service = factory(qualifier) as? T else {
            return nil
        }
        return service
    }
    
    /// Register an instance of a service of a certain type.
    ///
    /// Example:
    ///
    /// ```
    /// ServiceProvider.addServiceFactory() {
    ///     BinaryFile(filename: filename) as File
    /// }
    /// ```
    ///
    /// - parameter factory:
    ///     A factory block that creates an object of a specific type.
    ///     It is strongly recommended that the type be a protocol.
    ///
    public static func addServiceFactory<T: Any>(_ factory: @escaping (Qualifier?) -> T) {
        let identifier = Identifier(type: T.self, qualifier: nil)
        factories[identifier] = factory
    }
    
    /// Register an instance of a service of a certain type, with a
    /// qualifier to differentiate between services of the same type.
    ///
    /// Example:
    ///
    /// ```
    /// enum ServiceID: string {
    ///     case someSpecificFile
    ///     case otherFile
    /// }
    ///
    /// ServiceProvider.addServiceFactory(qualifier: ServiceID.someSpecificFile) {
    ///     BinaryFile(filename: filename) as File
    /// }
    /// ```
    ///
    /// - parameter qualifier:
    ///     Qualifier to differentiate this service from other services of the
    ///     same type. The qualifier must be a type that is raw representable
    ///     as string, e.g. an enum with a string raw value type.
    ///
    /// - parameter factory:
    ///     A factory block that creates an object of a specific type.
    ///     It is strongly recommended that the type be a protocol.
    ///
    public static func addServiceFactory<T: Any>(qualifier: Qualifier, factory: @escaping (Qualifier?) -> T) {
        let identifier = Identifier(type: T.self, qualifier: qualifier)
        factories[identifier] = factory
    }
    
    /// Register an instance of a service of a certain type.
    ///
    /// Example:
    ///
    /// ```
    /// ServiceProvider.addServiceFactory() {
    ///     BinaryFileProvider() as FileProvider
    /// }
    /// ```
    ///
    /// - parameter factory:
    ///     A factory block that creates an object of a specific type.
    ///     It is strongly recommended that the type be a protocol.
    ///     This method does not require a block that takes a qualifier
    ///     as input parameter.
    ///
    public static func addServiceFactory<T: Any>(_ factory: @escaping () -> T) {
        let identifier = Identifier(type: T.self, qualifier: nil)
        factories[identifier] = { _ in factory() }
    }
    
    /// Register an instance of a service of a certain type, with a qualifier.
    ///
    /// Example:
    ///
    /// ```
    /// ServiceProvider.addServiceFactory(qualifier: "me") {
    ///     BinaryFileProvider() as FileProvider
    /// }
    /// ```
    ///
    /// - parameter qualifier:
    ///     Qualifier to differentiate this service from other services of the
    ///     same type. The qualifier must be a type that is raw representable
    ///     as string, e.g. an enum with a string raw value type.
    ///
    /// - parameter factory:
    ///     A factory block that creates an object of a specific type.
    ///     It is strongly recommended that the type be a protocol.
    ///     This method does not require a block that takes a qualifier
    ///     as input parameter.
    ///
    public static func addServiceFactory<T: Any>(qualifier: Qualifier, factory: @escaping () -> T) {
        let identifier = Identifier(type: T.self, qualifier: qualifier)
        factories[identifier] = { _ in factory() }
    }
    
    /// Register an instance of a service of a certain type.
    ///
    /// Example:
    ///
    /// ```
    /// let fileStorageManager = FileStorageManager()
    /// ServiceProvider.addService(fileStorageManager as StorageManager)
    /// ServiceProvider.addService(TrackingService() as RESTService)
    /// ```
    ///
    /// - parameter factory:
    ///     An autoclosure returning the instance, cast to the registry type.
    ///     It is strongly recommended that the type be a protocol.
    ///
    public static func addService<T: Any>(_ factory: @autoclosure @escaping () -> T) {
        let identifier = Identifier(type: T.self, qualifier: nil)
        let service = factory()
        factories[identifier] = { _ in
            return service
        }
    }
    
    /// Register an instance of a service of a certain type, with a qualifier.
    ///
    /// Example:
    ///
    /// ```
    /// let fileStorageManager = FileStorageManager()
    /// ServiceProvider.addService(qualifier: "myTracking", TrackingService() as RESTService)
    /// ```
    ///
    /// - parameter qualifier:
    ///     Qualifier to differentiate this service from other services of the
    ///     same type. The qualifier must be a type that is raw representable
    ///     as string, e.g. an enum with a string raw value type.
    ///
    /// - parameter factory:
    ///     An autoclosure returning the instance, cast to the registry type.
    ///     It is strongly recommended that the type be a protocol.
    ///
    public static func addService<T: Any>(qualifier: Qualifier, _ factory: @autoclosure @escaping () -> T) {
        let identifier = Identifier(type: T.self, qualifier: qualifier)
        let service = factory()
        factories[identifier] = { _ in
            return service
        }
    }
}

// This is needed for ServiceProvider.Identifier to conform to the Equatable
// protocol which Hashable inherits from.
private func ==(lhs: ServiceProvider.Identifier,
                rhs: ServiceProvider.Identifier) -> Bool {
    return lhs.type == rhs.type && lhs.qualifier == rhs.qualifier
}
