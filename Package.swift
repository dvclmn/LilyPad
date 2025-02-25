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
  ],
  targets: [
    .target(
      name: "LilyPad",
      dependencies: [.product(name: "BaseHelpers", package: "BaseHelpers"),]
    ),
    .testTarget(
      name: "LilyPadTests",
      dependencies: ["LilyPad"]
    ),
  ]
)
