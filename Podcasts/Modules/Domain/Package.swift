// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private var networkLayer: Target.Dependency {
    .product(name: "NetworkLayer", package: "NetworkLayer")
}

private var packageDependency: [Package.Dependency] {
    [
        .package(url: "https://github.com/iNoor72/NetworkLayer", exact: "1.0.3"),
        .package(name: "Common", path: "../Common")
        
    ]
}

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Domain",
            targets: ["Domain"]),
    ],
    dependencies: packageDependency,
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Domain",
            dependencies: [networkLayer, .byName(name: "Common")]
        ),
    ],
    swiftLanguageModes: [.version("5.9")]
)
