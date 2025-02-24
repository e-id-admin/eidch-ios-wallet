// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITAnyCredentialFormat",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v16),
  ],
  products: [
    .library(
      name: "BITAnyCredentialFormat",
      targets: ["BITAnyCredentialFormat"]),
    .library(
      name: "BITAnyCredentialFormatMocks",
      targets: ["BITAnyCredentialFormatMocks"]),
  ],
  dependencies: [
    .package(path: "../../Platforms/BITCore"),
    .package(path: "../../Platforms/BITSdJWT"),
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
  ],
  targets: [
    .target(
      name: "BITAnyCredentialFormat",
      dependencies: [
        .product(name: "BITCore", package: "BITCore"),
        .product(name: "BITSdJWT", package: "BITSdJWT"),
        .product(name: "Spyable", package: "swift-spyable"),
      ]),
    .target(
      name: "BITAnyCredentialFormatMocks",
      dependencies: [
        "BITAnyCredentialFormat",
        .product(name: "BITSdJWTMocks", package: "BITSdJWT"),
        .product(name: "BITTestingCore", package: "BITCore"),
      ],
      resources: [.process("Resources")]),
    .testTarget(
      name: "BITAnyCredentialFormatTests",
      dependencies: ["BITAnyCredentialFormat", "BITAnyCredentialFormatMocks"]),
  ])
