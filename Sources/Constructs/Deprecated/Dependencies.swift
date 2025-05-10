//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

public protocol Dependable {
    static var defaultInstance: Self { get }
}

@available(*, deprecated, message: "Dependency is deprecated.")
@propertyWrapper
public class Dependency<T: Dependable>: DependencyProperty {

    private var value: T!

    private var keyPath: KeyPath<Dependencies, T>?

    public var wrappedValue: T {
        value
    }

    public init(_ keyPath: KeyPath<Dependencies, T>? = nil) {
        self.keyPath = keyPath
    }

    fileprivate func resolve(from dependencies: Dependencies) {
        if let keyPath = keyPath {
            value = dependencies.resolve(T.self, keyPath)
        } else {
            value = dependencies.resolve(T.self)
        }
    }
}

public struct Dependencies {

    private typealias Factory = () -> Any

    private var registry: [AnyHashable: Factory] = [:]

    public init() {
        //
    }

    private init(registry: [AnyHashable: Factory]) {
        self.registry = registry
    }

    public func adding<T: Dependable>(_ dependency: @autoclosure @escaping () -> T) -> Dependencies {
        var dependencies = Dependencies(registry: registry)
        dependencies.registry[DependencyIdentifier(T.self)] = dependency
        return dependencies
    }

    public func adding<T: Dependable>(_ keyPath: KeyPath<Dependencies, T>, _ dependency: @autoclosure @escaping () -> T) -> Dependencies {
        var dependencies = Dependencies(registry: registry)
        dependencies.registry[AnyHashable(keyPath)] = dependency
        return dependencies
    }

    public func resolve<T>(_ type: T.Type) -> T {
        guard let factory = registry[DependencyIdentifier(type)] else {
            preconditionFailure()
        }
        guard let value = factory() as? T else {
            preconditionFailure()
        }
        return value
    }

    public func resolve<T: Dependable>(_ type: T.Type, _ keyPath: KeyPath<Dependencies, T>) -> T {
        guard let factory = registry[AnyHashable(keyPath)] else {
            preconditionFailure()
        }
        guard let value = factory() as? T else {
            preconditionFailure()
        }
        return value
    }

    public func resolveProperties(for object: Any) {
        let mirror = Mirror(reflecting: object)
        for child in mirror.children {
            if let property = child.value as? DependencyProperty {
                property.resolve(from: self)
            }
        }
    }
}

fileprivate protocol DependencyProperty {
    func resolve(from dependencies: Dependencies)
}

private class DependencyIdentifier: Hashable {

    private var type: Any.Type

    public init(_ type: Any.Type) {
        self.type = type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }

    public static func == (lhs: DependencyIdentifier, rhs: DependencyIdentifier) -> Bool {
        return lhs.type == rhs.type
    }
}
