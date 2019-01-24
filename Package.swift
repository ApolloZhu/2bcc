// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "bcc",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(
            name: "2bcc",
            targets: ["2bcc"]),
        .library(
            name: "bcc",
            targets: ["bcc"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Carthage/Commandant.git", from: "0.15.0"),
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "3.1.4"),
        .package(url: "https://github.com/ApolloZhu/srt.git", from: "1.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "bcc",
            dependencies: ["srt"]),
        .target(
            name: "2bcc",
            dependencies: ["Commandant", "Rainbow", "bcc", "srt"]),
        .testTarget(
            name: "bccTests",
            dependencies: ["bcc"]),
    ]
)
