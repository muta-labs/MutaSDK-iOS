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
            url: "https://github.com/muta-labs/MutaSDK-iOS/releases/download/1.1.3/MutaSDK.xcframework.zip",
            checksum: "f2fade6d5940b96ab40d5ce3bf8ea808ca6444272bcf010b15aaed25da3f9d59"
        )
    ]
)