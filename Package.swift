// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlgoliaSearchClient",
    platforms: [
        .iOS(.v8),
        .macOS(.v10_15),
        .watchOS(.v2),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: "AlgoliaSearchClient",
            targets: ["AlgoliaSearchClient"])
    ],
    dependencies: [
        .package(url:"https://github.com/apple/swift-log.git", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "1.0.2")
    ],
    targets: [
        .target(
            name: "AlgoliaSearchClient",
            dependencies: ["Logging", "Crypto"]),
        .testTarget(
            name: "AlgoliaSearchClientTests",
            dependencies: ["AlgoliaSearchClient", "Logging", "Crypto"])
    ]
)
