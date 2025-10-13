// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "MutaSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "MutaSDK",
            targets: ["MutaSDK"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "MutaSDK",
            url: "https://github.com/muta-labs/MutaSDK-iOS/releases/download/1.1.1/MutaSDK.xcframework.zip",
            checksum: "8afd90dc1282f06264b19fc3d1341f781e6f8a31c81d81f02a8fb5db488d8b5a"
        )
    ]
)