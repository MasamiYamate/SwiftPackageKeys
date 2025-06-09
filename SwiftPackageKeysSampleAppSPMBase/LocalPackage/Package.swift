// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocalPackage",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LocalPackage",
            targets: ["LocalPackage"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/MasamiYamate/SwiftPackageKeys.git",
            revision: "53730cd26830192226db3fafe7ac62820af2d4d2"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LocalPackage",
            dependencies: [
                .product(name: "SwiftPackageKeys", package: "SwiftPackageKeys", condition: nil),
            ]
//            plugins: [
//                .plugin(name: "SwiftPackageKeysPlugin", package: "SwiftPackageKeys")
//            ]
        ),
    ]
)
