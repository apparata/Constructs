import XCTest
@testable import Constructs

final class ConstructsTests: XCTestCase {
    
    func testDependencies() {
        
        let mainDataFetcher = DataFetcher(data: "main")
        let otherDataFetcher = DataFetcher(data: "other")
        
        let dependencies = Dependencies()
            .adding(\.mainDataFetcher, mainDataFetcher)
            .adding(\.otherDataFetcher, otherDataFetcher)
        
        let fetcher1 = dependencies.resolve(DataFetcher.self, \.mainDataFetcher)
        XCTAssert(fetcher1.data == "main")
        
        let fetcher2 = dependencies.resolve(DataFetcher.self, \.otherDataFetcher)
        XCTAssert(fetcher2.data == "other")
    }
    
    static var allTests = [
        ("testDependencies", testDependencies),
    ]
}

struct DataFetcher {
    let data: String
}

extension DataFetcher: Dependable {
    static let defaultInstance = DataFetcher(data: "default")
}

extension Dependencies {
    var mainDataFetcher: DataFetcher { DataFetcher.defaultInstance }
    var otherDataFetcher: DataFetcher { DataFetcher.defaultInstance }
}
