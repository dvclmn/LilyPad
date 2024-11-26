// swift-tools-version: 6.0

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
  targets: [
    .target(
      name: "LilyPad"),
    .testTarget(
      name: "LilyPadTests",
      dependencies: ["LilyPad"]
    ),
  ]
)
