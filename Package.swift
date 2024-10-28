// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let githubReleaseDir = "0.7.3"
let sdkVersion = "0.7.3"
let sdkZipfileChecksum = "1a6febc5d0bcc2d14c8578fa77a349973434f50ac78d486a61990c4ba3b4267a"

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

