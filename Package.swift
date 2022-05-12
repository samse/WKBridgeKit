// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "WKBridgeKit",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "WKBridgeKit",
                 targets: ["WKBridgeKit"])
    ],
    dependencies: [
        .package(name:"KeychainAccess", url: "https://github.com/kishikawakatsumi/KeychainAccess.git", .exact("4.2.2")),
        .package(name:"SwiftyJSON", url: "https://github.com/SwiftyJSON/SwiftyJSON.git", .exact("5.0.1")),
        .package(name:"Reachability", url: "https://github.com/ashleymills/Reachability.swift.git", .exact("5.10"))
    ],
    targets: [
        .target(name: "WKBridgeKit",
                dependencies: ["SwiftyJSON", "KeychainAccess", "Reachability"],
                path: "WKBridgeKit")
    ],
    swiftLanguageVersions: [
        .v5
    ]
)

