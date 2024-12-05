// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITSecurity",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITSecurity",
      targets: ["BITSecurity"]),
  ],
  dependencies: [
    .package(url: "https://github.com/hmlongco/Factory", .upToNextMajor(from: "2.1.4")),
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
    .package(path: "../BITTheming"),
  ],
  targets: [
    .target(
      name: "BITSecurity",
      dependencies: [
        .product(name: "BITTheming", package: "BITTheming"),
        .product(name: "Factory", package: "Factory"),
        .product(name: "Spyable", package: "swift-spyable"),
      ]),
    .testTarget(
      name: "BITSecurityTests",
      dependencies: [
        "BITSecurity",
      ]),
  ])
