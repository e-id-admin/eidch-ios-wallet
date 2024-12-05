// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "BITTheming",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITTheming",
      targets: ["BITTheming"]),
  ],
  dependencies: [
    .package(path: "../../Platforms/BITL10n"),
    .package(url: "https://github.com/siteline/swiftui-introspect", exact: "1.1.1"),
    .package(url: "https://github.com/airbnb/lottie-ios", exact: "4.4.3"),
  ],
  targets: [
    .target(
      name: "BITTheming",
      dependencies: [
        .product(name: "BITL10n", package: "BITL10n"),
        .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
        .product(name: "Lottie", package: "lottie-ios"),
      ],
      resources: [
        .process("Resources"),
      ]),
    .testTarget(
      name: "BITThemingTests",
      dependencies: ["BITTheming"]),
  ])
