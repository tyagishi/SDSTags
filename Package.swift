// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SDSTags",
    platforms: [
        .macOS(.v14),
        .iOS(.v16),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SDSTags",
            targets: ["SDSTags"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/tyagishi/SDSCustomView.git", from: "3.4.0"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.54.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SDSTags",
            dependencies: ["SDSCustomView"],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]),
        .testTarget(
            name: "SDSTagsTests",
            dependencies: ["SDSTags"]),
    ]
)
