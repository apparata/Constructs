//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

import Foundation

public enum VersionNumberError: Error {
    case invalidVersionNumber
}

/// Represents a version number on the form \d+(\.\d+)+
///
/// - Example:
/// ```
/// let v1 = try? VersionNumber("1.2.3")
/// let v2 = VersionNumber(parts: [1, 5, 2])
/// let v3 = VersionNumber(parts: 1, 5, 2, 1)
/// v1 == v2
/// v1 < v2
/// v1 > v2
/// v2 == v3
/// v2 < v3
/// v2 > v3
/// ```
public struct VersionNumber: Comparable, Codable {
        
    let parts: [Int]
        
    public init(parts: Int...) {
        self.parts = parts
    }
    
    public init(parts: [Int]) {
        self.parts = parts
    }
    
    public init(_ versionString: String) throws {
        guard Self.isValidVersionNumber(versionString) else {
            throw VersionNumberError.invalidVersionNumber
        }
        parts = versionString.components(separatedBy: ".").compactMap { Int($0) }
    }
    
    private static func isValidVersionNumber(_ string: String) -> Bool {
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = nil
        
        let digits = CharacterSet(charactersIn: "0123456789")
        guard scanner.scanCharacters(from: digits) != nil else {
            return false
        }
        guard scanner.scanString(".") != nil else {
            return false
        }
        while scanner.scanCharacters(from: digits) != nil {
            if scanner.isAtEnd {
                return true
            }
            guard scanner.scanString(".") != nil else {
                return false
            }
        }
        
        return false
    }
}

// MARK: Object Description

extension VersionNumber: CustomStringConvertible {
    
    public var string: String {
        return parts.map({ String($0) }).joined(separator: ".")
    }
    
    public var description: String {
        return string
    }
}

// MARK: Hashable

extension VersionNumber: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }
}

// MARK: Comparable

public func <(lhs: VersionNumber, rhs: VersionNumber) -> Bool {
    for i in 0..<min(lhs.parts.count, rhs.parts.count) {
        if lhs.parts[i] == rhs.parts[i] {
            continue
        } else if lhs.parts[i] < rhs.parts[i] {
            return true
        } else {
            return false
        }
    }
    return lhs.parts.count < rhs.parts.count
}

// MARK: Equatable

public func ==(lhs: VersionNumber, rhs: VersionNumber) -> Bool {
    if lhs.parts.count != rhs.parts.count {
        return false
    }
    for i in 0..<lhs.parts.count {
        if lhs.parts[i] != rhs.parts[i] {
            return false
        }
    }
    return true
}

