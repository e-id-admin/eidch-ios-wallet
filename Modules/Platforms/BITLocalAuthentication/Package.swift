// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITLocalAuthentication",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITLocalAuthentication",
      targets: ["BITLocalAuthentication"]),
  ],
  dependencies: [
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
  ],
  targets: [
    .target(
      name: "BITLocalAuthentication",
      dependencies: [
        .product(name: "Spyable", package: "swift-spyable"),
      ]),
    .target(
      name: "BITLocalAuthenticationMocks",
      dependencies: [
        "BITLocalAuthentication",
      ]),
    .testTarget(
      name: "BITLocalAuthenticationTests",
      dependencies: [
        "BITLocalAuthentication",
        "BITLocalAuthenticationMocks",
      ]),
  ])
