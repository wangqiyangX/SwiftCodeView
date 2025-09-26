// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftCodeView",
    platforms: [.iOS(.v26), .macOS(.v26)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftCodeView",
            targets: ["SwiftCodeView"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/ChimeHQ/SwiftTreeSitter",
            branch: "main"
        ),
        .package(
            url: "https://github.com/alex-pinkus/tree-sitter-swift",
            branch: "with-generated-files"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftCodeView",
            dependencies: [
                "SwiftTreeSitter",
                .product(name: "TreeSitterSwift", package: "tree-sitter-swift"),
            ]
        ),
        .testTarget(
            name: "SwiftCodeViewTests",
            dependencies: ["SwiftCodeView"]
        ),
    ]
)
