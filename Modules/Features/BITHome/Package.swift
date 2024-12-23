// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITHome",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITHome",
      targets: ["BITHome"]),
  ],
  dependencies: [
    .package(path: "../../Platforms/BITL10n"),
    .package(path: "../../Platforms/BITCore"),
    .package(path: "../../Platforms/BITNavigation"),
    .package(path: "../../Features/BITCredential"),
    .package(path: "../../Features/BITInvitation"),
    .package(path: "../../Features/BITSettings"),
    .package(path: "../../Platforms/BITTheming"),
    .package(path: "../../Platforms/BITDataStore"),
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.2.0"),
    .package(path: "../../Platforms/BITAnalytics"),
    .package(path: "../BITCredentialShared"),
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
    .package(url: "https://github.com/gh123man/SwiftUI-Refresher", exact: "1.1.8"),
    .package(url: "https://github.com/realm/realm-swift", exact: "10.50.0"),
  ],
  targets: [
    .target(
      name: "BITHome",
      dependencies: [
        .product(name: "BITL10n", package: "BITL10n"),
        .product(name: "BITCore", package: "BITCore"),
        .product(name: "BITNavigation", package: "BITNavigation"),
        .product(name: "BITCredential", package: "BITCredential"),
        .product(name: "BITInvitation", package: "BITInvitation"),
        .product(name: "BITSettings", package: "BITSettings"),
        .product(name: "BITTheming", package: "BITTheming"),
        .product(name: "BITDataStore", package: "BITDataStore"),
        .product(name: "BITAnalytics", package: "BITAnalytics"),
        .product(name: "BITCredentialShared", package: "BITCredentialShared"),
        .product(name: "Factory", package: "Factory"),
        .product(name: "Spyable", package: "swift-spyable"),
        .product(name: "Refresher", package: "SwiftUI-Refresher"),
        .product(name: "RealmSwift", package: "realm-swift"),
      ]),
    .testTarget(
      name: "BITHomeTests",
      dependencies: [
        "BITHome",
        .product(name: "BITTestingCore", package: "BITCore"),
        .product(name: "BITCredentialMocks", package: "BITCredential"),
      ]),
  ])
