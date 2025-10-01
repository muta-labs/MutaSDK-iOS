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
            url: "https://firebasestorage.googleapis.com/v0/b/muta-ae90b.firebasestorage.app/o/releases%2Fv1.1.0%2FMutaSDK.xcframework.zip?alt=media&token=e41150fa-d3a2-4f92-9b70-13d35dc35aa5",
            checksum: "0bd2e9b5959787ee377a4b5676b757c073a7af7f39a3d98810888adb42f5cdee"
        )
    ]
)