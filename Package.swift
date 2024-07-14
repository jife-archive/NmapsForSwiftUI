// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "NmapsForSwiftUI",
    products: [
        .library(
            name: "NmapsForSwiftUI",
            targets: ["NmapsForSwiftUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/stleamist/NMapsMap-SwiftPM.git", from: "3.11.0")
    ],
    targets: [
        .target(
            name: "NmapsForSwiftUI",
            dependencies: [
                .product(name: "NMapsMap", package: "NMapsMap-SwiftPM")
            ]),
        .testTarget(
            name: "NmapsForSwiftUITests",
            dependencies: ["NmapsForSwiftUI"]),
    ]
)


