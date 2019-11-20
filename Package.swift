// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MachOParser",
    dependencies: [],
    targets: [
        .target(
            name: "MachOParser",
            dependencies: []),
        .testTarget(
            name: "MachOParserTests",
            dependencies: ["MachOParser"]),
    ]
)
