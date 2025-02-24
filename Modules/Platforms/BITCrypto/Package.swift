// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITCrypto",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v16),
  ],
  products: [
    .library(
      name: "BITCrypto",
      targets: ["BITCrypto"]),
  ],
  dependencies: [
    .package(path: "../../Platforms/BITCore"),
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
    .package(url: "git@github.com:krzyzanowskim/CryptoSwift.git", exact: "1.8.3"),
  ],
  targets: [
    .target(
      name: "BITCrypto",
      dependencies: [
        .product(name: "BITCore", package: "BITCore"),
        .product(name: "BITTestingCore", package: "BITCore"),
        .product(name: "Spyable", package: "swift-spyable"),
        .product(name: "CryptoSwift", package: "CryptoSwift"),
      ],
      resources: [.process("Resources")],
      swiftSettings: [
        .define("DEBUG", .when(configuration: .debug)),
      ]),
    .testTarget(
      name: "BITCryptoTests",
      dependencies: [
        "BITCrypto",
      ],
      swiftSettings: [
        .define("DEBUG", .when(configuration: .debug)),
      ]),
  ])
