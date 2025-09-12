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
            url: "https://firebasestorage.googleapis.com/v0/b/muta-ae90b.firebasestorage.app/o/releases%2Fv1.0.4%2FMutaSDK.xcframework.zip?alt=media&token=02f19dbd-4f3c-447d-9959-802036edaa61",
            checksum: "5238719ff95ed48473a4023a5c65c2ba284abc8cc2d7ad88a10057347f5a34c3"
        )
    ]
)