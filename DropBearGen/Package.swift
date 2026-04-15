// swift-tools-version:6.3

import Foundation
import PackageDescription

let package = Package(
    name: "DropBearGen",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "DropBearGen", targets: ["DropBearGen"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.1"),
        .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "5.2.7")
    ],
    targets: [
        .executableTarget(
            name: "DropBearGen",
            dependencies: [
                "Kanna",
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "DropBearGenTests",
            dependencies: ["DropBearGen"]
        )
    ]
)
