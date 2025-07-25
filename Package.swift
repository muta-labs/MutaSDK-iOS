// swift-tools-version:5.5
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
            url: "https://firebasestorage.googleapis.com/v0/b/muta-ae90b.firebasestorage.app/o/releases%2Fv1.0.1%2FMutaSDK.xcframework.zip?alt=media&token=a1b12592-a580-4c7d-bc1a-957b9e783a7d",
            checksum: "7ead33a7f43db8ece4652ef789958e561af06fcd464350c0438d00819f3fcc0d"
        )
    ]
)