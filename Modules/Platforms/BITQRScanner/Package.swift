// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITQRScanner",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITQRScanner",
      targets: ["BITQRScanner"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "BITQRScanner",
      dependencies: []),
    .testTarget(
      name: "BITQRScannerTests",
      dependencies: ["BITQRScanner"]),
  ])
