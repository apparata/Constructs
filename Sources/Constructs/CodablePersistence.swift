//
//  Copyright © 2020 Apparata AB. All rights reserved.
//


import Foundation

/// A helper class for saving and loading Codable data to and from the documents directory.
///
/// Data is persisted to a file located in the app's documents folder using JSON encoding and decoding.
/// All read and write operations are performed asynchronously on a dedicated background queue.
/// 
public class CodablePersistence {

    private let queue = DispatchQueue(label: "codablepersistence.data", qos: .userInitiated)

    private let url: URL

    /// Initializes a new persistence helper with a specific filename.
    ///
    /// - Parameter filename: The name of the file where data will be saved and loaded.
    /// The file is stored in the app's documents directory.
    public init(filename: String) {
        url = URL(fileInDocuments: filename)
    }

    /// Asynchronously loads decodable data from a file in the documents directory.
    ///
    /// - Parameters:
    ///   - value: The default value to return if loading or decoding fails.
    ///   - completion: A closure called on the main thread with the loaded or default value.
    public func load<T: Decodable>(default value: T, completion: @escaping (T) -> Void) {
        queue.async { [url] in
            var data: T = value
            do {
                if url.fileExists {
                    let json = try Data(contentsOf: url)
                    data = try JSONDecoder().decode(T.self, from: json)
                }
            } catch {
                dump(error)
            }
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }

    /// Asynchronously saves codable data to a file in the documents directory.
    ///
    /// - Parameter data: The data to be encoded and saved.
    public func save<T: Codable>(_ data: T) {
        queue.async { [url] in
            do {
                let json = try JSONEncoder().encode(data)
                try json.write(to: url, options: .atomic)
            } catch {
                dump(error)
            }
        }
    }
}
