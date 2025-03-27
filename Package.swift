// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let githubReleaseDir = "0.7.4"
let sdkVersion = "0.7.4"
let sdkZipfileChecksum = "96efd9a70c1d7500ee3ebb5f1b3cc7f328261d48a348d9a633ecc7c7f28ebd37"

let package = Package(
    name: "MopinionSDKWeb",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MopinionSDK",
            targets: ["MopinionSDK"]),
    ],
    targets: [
       .binaryTarget(
       		name: "MopinionSDK",
       		url: "https://github.com/Mopinion-com/mopinion-sdk-ios-web-swiftpm/releases/download/\(githubReleaseDir)/MopinionSDKWeb-\(sdkVersion).xcframework.zip",
       		checksum: sdkZipfileChecksum )     
    ]
)

