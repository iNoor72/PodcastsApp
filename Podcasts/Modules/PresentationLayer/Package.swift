// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private var packageDependency: [Package.Dependency] {
    [
        .package(name: "Domain", path: "../Domain"),
        .package(name: "Common", path: "../Common"),
        .package(name: "DesignSystem", path: "../DesignSystem"),
        .package(name: "Data", path: "../Data")
    ]
}

let package = Package(
    name: "PresentationLayer",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PresentationLayer",
            targets: ["PresentationLayer"]),
    ],
    dependencies: packageDependency,

    targets: [
        .target(
            name: "PresentationLayer",
            dependencies: [
                "Domain",
                "Data",
                "Common",
                "DesignSystem"
            ],
        )
    ],
    swiftLanguageModes: [.version("5.9")]
)
