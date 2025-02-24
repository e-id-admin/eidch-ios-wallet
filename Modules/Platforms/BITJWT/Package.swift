// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITJWT",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v16),
  ],
  products: [
    .library(
      name: "BITJWT",
      targets: ["BITJWT"]),
  ],
  dependencies: [
    .package(path: "../../Platforms/BITCore"),
    .package(path: "../../Platforms/BITAnalytics"),
    .package(path: "../../Platforms/BITCrypto"),
    .package(path: "../../Platforms/BITNetworking"),
    .package(url: "https://github.com/e-id-admin/didresolver-swift.git", exact: "1.0.1"),
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.2.0"),
    .package(url: "https://github.com/airsidemobile/JOSESwift.git", exact: "2.4.0"),
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
  ],
  targets: [
    .target(
      name: "BITJWT",
      dependencies: [
        .product(name: "BITCore", package: "BITCore"),
        .product(name: "BITTestingCore", package: "BITCore"),
        .product(name: "BITAnalytics", package: "BITAnalytics"),
        .product(name: "BITCrypto", package: "BITCrypto"),
        .product(name: "BITNetworking", package: "BITNetworking"),
        .product(name: "DidResolver", package: "didresolver-swift"),
        .product(name: "Factory", package: "Factory"),
        .product(name: "JOSESwift", package: "JOSESwift"),
        .product(name: "Spyable", package: "swift-spyable"),
      ],
      resources: [.process("Resources")],
      swiftSettings: [.define("DEBUG", .when(configuration: .debug))]),
    .testTarget(
      name: "BITJWTTests",
      dependencies: [
        "BITJWT",
        .product(name: "BITTestingCore", package: "BITCore"),
      ]),
  ])
