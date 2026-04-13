// swift-tools-version:5.3
import Foundation
import PackageDescription

let package = Package(
    name: "DropBear",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "DropBear", targets: ["DropBear"]),
        .library(name: "DropBearSupport", targets: ["DropBearSupport"]),
    ],
    dependencies: [
    ],
    targets: [
        // Library
        .target(
            name: "DropBear",
            linkerSettings: [.linkedFramework("XCTest")]
        ),
        .testTarget(
            name: "DropBearTests",
            dependencies: ["DropBear"]
        ),

        // App Support
        .target(
            name: "DropBearSupport"
        ),
        .testTarget(
            name: "DropBearSupportTests",
            dependencies: ["DropBearSupport"]
        ),
    ]
)
