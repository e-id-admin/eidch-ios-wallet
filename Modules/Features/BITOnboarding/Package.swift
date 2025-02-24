// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITOnboarding",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v16),
  ],
  products: [
    .library(
      name: "BITOnboarding",
      targets: ["BITOnboarding"]),
  ],
  dependencies: [
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.2.0"),
    .package(path: "../../Platforms/BITL10n"),
    .package(path: "../../Platforms/BITCore"),
    .package(path: "../../Platforms/BITAnalytics"),
    .package(path: "../../Platforms/BITSettings"),
    .package(path: "../BITAppAuth"),
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
    .package(url: "https://github.com/exyte/PopupView", exact: "3.0.0"),
  ],
  targets: [
    .target(
      name: "BITOnboarding",
      dependencies: [
        .product(name: "Factory", package: "Factory"),
        .product(name: "BITL10n", package: "BITL10n"),
        .product(name: "BITCore", package: "BITAppAuth"),
        .product(name: "BITAnalytics", package: "BITAnalytics"),
        .product(name: "BITAppAuth", package: "BITAppAuth"),
        .product(name: "BITSettings", package: "BITSettings"),
        .product(name: "Spyable", package: "swift-spyable"),
        .product(name: "PopupView", package: "PopupView"),
      ],
      resources: [.process("Resources")]),
    .testTarget(
      name: "BITOnboardingTests",
      dependencies: ["BITOnboarding"]),
  ])
