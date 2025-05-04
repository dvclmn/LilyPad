// swift-tools-version: 5.10

import PackageDescription

let package = Package(
  name: "LilyPad",
  platforms: [
    .macOS("14.0")
  ],
  products: [
    .library(
      name: "LilyPad",
      targets: ["LilyPad"]),
  ],
  dependencies: [
    .package(url: "https://github.com/dvclmn/BaseHelpers", branch: "main"),
    .package(url: "https://github.com/dvclmn/BaseComponents", branch: "main"),
  ],
  targets: [
    .target(
      name: "LilyPad",
      dependencies: [
        .product(name: "BaseHelpers", package: "BaseHelpers"),
        .product(name: "BaseComponents", package: "BaseComponents"),
      ]
    ),
    .testTarget(
      name: "LilyPadTests",
      dependencies: ["LilyPad"]
    ),
  ]
)
