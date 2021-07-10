//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

public class CodablePersistence {
    
    private let queue = DispatchQueue(label: "codablepersistence.data", qos: .userInitiated)
    
    private let url: URL

    /// The file is stored in the documents folder.
    public init(filename: String) {
        url = URL(fileInDocuments: filename)
    }
    
    /// Load decodable data from file in documents folder.
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
    
    /// Save encodable data to file in documents folder.
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
