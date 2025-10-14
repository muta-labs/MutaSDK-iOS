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
            url: "https://github.com/muta-labs/MutaSDK-iOS/releases/download/1.1.2/MutaSDK.xcframework.zip",
            checksum: "373e27eb4733d19ac445a5e473d71efaaa3d07dfef4842a60ddfbf4e44a1095f"
        )
    ]
)