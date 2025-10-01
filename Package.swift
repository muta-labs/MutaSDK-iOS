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
            url: "https://github.com/muta-labs/MutaSDK-iOS/releases/download/1.1.0/MutaSDK.xcframework.zip",
            checksum: "0bd2e9b5959787ee377a4b5676b757c073a7af7f39a3d98810888adb42f5cdee"
        )
    ]
)