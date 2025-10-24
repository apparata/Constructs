// swift-tools-version:6.1

import PackageDescription

let package = Package(
    name: "Constructs",
    platforms: [
        // Relevant platforms.
        .iOS(.v15), .macOS(.v13), .tvOS(.v15), .visionOS(.v1)
    ],
    products: [
        .library(name: "Constructs", targets: ["Constructs"])
    ],
    dependencies: [
        // It's a good thing to keep things relatively
        // independent, but add any dependencies here.
    ],
    targets: [
        .target(
            name: "Constructs",
            dependencies: [],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
                .define("SWIFT_PACKAGE")
            ]),
        .testTarget(name: "ConstructsTests", dependencies: ["Constructs"])
    ]
)
