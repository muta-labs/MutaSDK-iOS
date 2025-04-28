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
            url: "https://firebasestorage.googleapis.com/v0/b/muta-ae90b.firebasestorage.app/o/releases%2Fv1.0.0%2FMutaSDK.xcframework.zip?alt=media&token=ad1dd8ff-043e-43fc-a7b6-7ca8d14e43b0",
            checksum: "38d1c2ca6fa4958eacf42787e6dfcdf4476e7c326a23eb600211693f4d7fe5be"
        )
    ]
) 