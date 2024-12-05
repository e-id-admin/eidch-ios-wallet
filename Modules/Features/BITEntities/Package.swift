// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITEntities",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITEntities",
      targets: ["BITEntities"]),
  ],
  dependencies: [
    .package(path: "../../Platforms/BITDataStore"),
    .package(url: "https://github.com/realm/realm-swift", exact: "10.50.0"),
  ],
  targets: [
    .target(
      name: "BITEntities",
      dependencies: [
        .product(name: "BITDataStore", package: "BITDataStore"),
        .product(name: "RealmSwift", package: "realm-swift"),
      ]),
    .testTarget(
      name: "BITEntitiesTests",
      dependencies: [
        "BITEntities",
        .product(name: "RealmSwift", package: "realm-swift"),
      ]),
  ])
