// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITAppVersion",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v16),
  ],
  products: [
    .library(
      name: "BITAppVersion",
      targets: ["BITAppVersion"]),
  ],
  dependencies: [
    .package(path: "../../Platforms/BITCore"),
    .package(path: "../../Platforms/BITAnalytics"),
    .package(path: "../../Platforms/BITL10n"),
    .package(path: "../../Platforms/BITTheming"),
    .package(path: "../../Platforms/BITNavigation"),
    .package(path: "../../Platforms/BITNetworking"),
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.2.0"),
    .package(url: "https://github.com/Matejkob/swift-spyable", exact: "0.8.0"),
  ],
  targets: [
    .target(
      name: "BITAppVersion",
      dependencies: [
        .product(name: "BITCore", package: "BITCore"),
        .product(name: "BITTestingCore", package: "BITCore"),
        .product(name: "BITL10n", package: "BITL10n"),
        .product(name: "BITNetworking", package: "BITNetworking"),
        .product(name: "BITNavigation", package: "BITNavigation"),
        .product(name: "Factory", package: "Factory"),
        .product(name: "Spyable", package: "swift-spyable"),
        .product(name: "BITTheming", package: "BITTheming"),
        .product(name: "BITAnalytics", package: "BITAnalytics"),
      ],
      resources: [.process("Resources")],
      swiftSettings: [
        .define("DEBUG", .when(configuration: .debug)),
      ]),
    .testTarget(
      name: "BITAppVersionTests",
      dependencies: [
        "BITAppVersion",
      ],
      swiftSettings: [
        .define("DEBUG", .when(configuration: .debug)),
      ]),
  ])
