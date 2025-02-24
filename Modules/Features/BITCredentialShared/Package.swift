// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#warning("Remove OpenID reference when DisplayLocalizable is refactor out of BITOpenID")
let package = Package(
  name: "BITCredentialShared",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v16),
  ],
  products: [
    .library(
      name: "BITCredentialShared",
      targets: ["BITCredentialShared"]),
  ],
  dependencies: [
    .package(path: "../../Platforms/BITCore"),
    .package(path: "../../Platforms/BITVault"),
    .package(path: "../../Platforms/BITAnyCredentialFormat"),
    .package(path: "../BITEntities"),
    .package(path: "../BITOpenID"),
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.2.0"),
  ],
  targets: [
    .target(
      name: "BITCredentialShared",
      dependencies: [
        .product(name: "BITCore", package: "BITCore"),
        .product(name: "BITTestingCore", package: "BITCore"),
        .product(name: "BITVault", package: "BITVault"),
        .product(name: "BITOpenID", package: "BITOpenID"),
        .product(name: "BITAnyCredentialFormat", package: "BITAnyCredentialFormat"),
        .product(name: "BITEntities", package: "BITEntities"),
        .product(name: "Factory", package: "Factory"),
      ],
      resources: [.process("Resources")],
      swiftSettings: [
        .define("DEBUG", .when(configuration: .debug)),
      ]),
    .testTarget(
      name: "BITCredentialSharedTests",
      dependencies: [
        "BITCredentialShared",
      ],
      swiftSettings: [
        .define("DEBUG", .when(configuration: .debug)),
      ]),
  ])
