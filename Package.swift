// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPackageKeys",
    products: [
        .library(
            name: "SwiftPackageKeys",
            targets: ["SwiftPackageKeys"]),
    ],
    targets: [
        .target(
            name: "SwiftPackageKeys",
            dependencies: [],
            plugins: [.plugin(name: "EnvironmentKeyPlugin")]
        ),
        .plugin(
            name: "EnvironmentKeyPlugin",
            capability: .buildTool()
        )
    ]
)
