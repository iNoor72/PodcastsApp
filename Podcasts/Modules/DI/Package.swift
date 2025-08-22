// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private var targets: [Target.Dependency] {
    [
        .byName(name: "Domain"),
        .byName(name: "Data"),
        .byName(name: "Common"),
        .byName(name: "HomeScreen"),
        .byName(name: "SearchScreen")
    ]
}

private var packageDependency: [Package.Dependency] {
    [
        .package(name: "Domain", path: "../Domain"),
        .package(name: "Data", path: "../Data"),
        .package(name: "Common", path: "../Common"),
        .package(name: "HomeScreen", path: "../HomeScreen"),
        .package(name: "SearchScreen", path: "../SearchScreen")
    ]
}

let package = Package(
    name: "DI",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DI",
            targets: ["DI"]),
    ],
    dependencies: packageDependency,
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DI",
            dependencies: targets
        ),
        
    ]
)
