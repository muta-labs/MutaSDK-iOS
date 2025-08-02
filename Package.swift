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
            url: "https://firebasestorage.googleapis.com/v0/b/muta-ae90b.firebasestorage.app/o/releases%2Fv1.0.3%2FMutaSDK.xcframework.zip?alt=media&token=43c42f89-46e0-42fe-ace6-be6cd462a172",
            checksum: "9662ac32a1f15319fb14bace4e7d606f0e623fce832e0e3535390c0590dabe3a"
        )
    ]
)