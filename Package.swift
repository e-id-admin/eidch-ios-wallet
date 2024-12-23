// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "swiyu-Danger",
  defaultLocalization: "en",
  products: [
    .library(name: "DangerDeps", type: .dynamic, targets: ["swiyu-Danger"]),
  ],
  dependencies: [
    .package(url: "https://github.com/danger/swift.git", from: "3.15.0"),
  ],
  targets: [
    .target(
      name: "swiyu-Danger",
      dependencies: [
        .product(name: "Danger", package: "swift"),
      ],
      path: "swiyu",
      sources: ["Resources/DangerProxy.swift"]),
  ])
