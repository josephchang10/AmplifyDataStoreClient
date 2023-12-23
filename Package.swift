// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AmplifyDataStoreClient",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AmplifyDataStoreClient",
            targets: ["AmplifyDataStoreClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
        .package(url: "https://github.com/replicate/replicate-swift", from: "0.20.0"),
        .package(url: "https://github.com/aws-amplify/amplify-swift", from: "2.25.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AmplifyDataStoreClient",
            dependencies: [
                .product(name: "Replicate", package: "replicate-swift"),
                .product(name: "Amplify", package: "amplify-swift"),
                .product(name: "Dependencies", package: "swift-dependencies")
            ]
        ),
        .testTarget(
            name: "AmplifyDataStoreClientTests",
            dependencies: ["AmplifyDataStoreClient"]),
    ]
)
