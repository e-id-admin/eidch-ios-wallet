// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITL10n",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITL10n",
      targets: ["BITL10n"]),
  ],
  targets: [
    .target(
      name: "BITL10n",
      resources: [
        .process("Resources"),
      ]),
    .testTarget(
      name: "BITL10nTests",
      dependencies: ["BITL10n"]),
  ])
