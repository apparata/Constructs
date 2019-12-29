//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

import Foundation

/// An enum that indicates the success or failure of an arbitrary operation.
/// The operation is expected to return a value on success or an error
/// on failure. It is typically used for return the result of an asynchronous
/// operation or any other operation that doesn't lend itself to try/catch.
public enum ResultWithMetadata<Value, Metadata, Error: Swift.Error> {
    
    /// Indicates that the operation was a success. The associated value is the
    /// is the resulting value of the operation, accompanied by arbitrary
    /// metadata.
    case success(Value, Metadata)
    
    /// Indicates that the operation failed. The associated value is an
    /// error that indicates the reason for the failure.
    case failure(Error)
    
    /// Initialize as success with associated value, accompanied by arbitrary
    /// metadata.
    public init(_ value: Value, _ metadata: Metadata) {
        self = .success(value, metadata)
    }
    
    /// Initialize as success with associated value and metadata as a tuple.
    public init(_ tuple: (Value, Metadata)) {
        self = .success(tuple.0, tuple.1)
    }
    
    /// Initialize as failure with associated error.
    public init(_ error: Error) {
        self = .failure(error)
    }
    
    /// Initialize with, and call, an action that might throw.
    public init(_ action: () throws -> (Value, Metadata)) throws {
        do {
            let (value, metadata) = try action()
            self = .success(value, metadata)
        } catch let error as Error {
            self = .failure(error)
        }
    }
    
    /// Uses transform closure to map the result to a result with a
    /// different value type.
    public func map<T, M>(_ transform: (Value, Metadata) throws -> (T, M)) rethrows -> ResultWithMetadata<T, M, Error> {
        switch self {
        case .success(let value, let metadata):
            return ResultWithMetadata<T, M, Error>(try transform(value, metadata))
        case .failure(let error):
            return ResultWithMetadata<T, M, Error>(error)
        }
    }
    
    /// Either get the value if success, or throw the error, if failure.
    public func resolve() throws -> (Value, Metadata) {
        switch self {
        case .success(let value, let metadata):
            return (value, metadata)
        case .failure(let error):
            throw error
        }
    }
}

extension ResultWithMetadata: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .success(let value):
            return "Result(success: \(value))"
        case .failure(let error):
            return "Result(failure: \(error))"
        }
    }
}

