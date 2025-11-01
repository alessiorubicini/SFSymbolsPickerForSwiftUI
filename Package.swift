// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SFSymbolsPicker",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "SFSymbolsPicker",
            targets: ["SFSymbolsPicker"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", .upToNextMajor(from: "7.0.0"))
    ],
    targets: [
        .target(name: "SFSymbolsPicker", dependencies: ["SFSafeSymbols"])
    ]
)
