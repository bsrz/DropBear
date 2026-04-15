// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "DropBear",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "DropBear", targets: ["DropBear"]),
        .library(name: "DropBearSupport", targets: ["DropBearSupport"]),
    ],
    dependencies: [],
    targets: [
        // Library
        .target(name: "DropBear", linkerSettings: [.linkedFramework("XCTest")]),
        .testTarget(name: "DropBearTests", dependencies: ["DropBear"]),

        // App Support
        .target(name: "DropBearSupport"),
        .testTarget(name: "DropBearSupportTests", dependencies: ["DropBearSupport"]),
    ]
)
