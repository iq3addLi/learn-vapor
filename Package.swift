// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "learn-vapor",
    products: [
        .executable(name: "learn-vapor", targets: ["Main"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "3.3.1"),
        .package(url: "https://github.com/vapor/jwt-kit", from: "3.0.0"),
    ],
    targets: [
        .target(name: "Main", dependencies: [
            "Vapor",
            "JWT",
        ]),
        .testTarget(name: "learn-vaporTests", dependencies: ["Main"]),
    ]
)
