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
    .package(url: "https://github.com/dvclmn/BaseMacros", branch: "main"),
//    .package(url: "https://github.com/dvclmn/BaseComponents", branch: "main"),
    .package(url: "https://github.com/gohanlon/swift-memberwise-init-macro.git", from: "0.5.1"),
    .package(url: "https://github.com/pointfreeco/swift-identified-collections.git", branch: "main"),
    
    
  ],
  targets: [
    .target(
      name: "LilyPad",
      dependencies: [
        .product(name: "BaseMacros", package: "BaseMacros"),
        .product(name: "BaseHelpers", package: "BaseHelpers"),
//        .product(name: "BaseComponents", package: "BaseComponents"),
        .product(name: "MemberwiseInit", package: "swift-memberwise-init-macro"),
        .product(name: "IdentifiedCollections", package: "swift-identified-collections")
      ]
    ),
    .testTarget(
      name: "LilyPadTests",
      dependencies: ["LilyPad"]
    ),
  ]
)
