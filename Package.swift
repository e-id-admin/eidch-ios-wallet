// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "publicBetaWallet-Danger",
  defaultLocalization: "en",
  products: [
    .library(name: "DangerDeps", type: .dynamic, targets: ["publicBetaWallet-Danger"]),
  ],
  dependencies: [
    .package(url: "https://github.com/danger/swift.git", from: "3.15.0"),
  ],
  targets: [
    .target(
      name: "publicBetaWallet-Danger",
      dependencies: [
        .product(name: "Danger", package: "swift"),
      ],
      path: "publicBetaWallet",
      sources: ["Resources/DangerProxy.swift"]),
  ])
