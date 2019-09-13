// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "LayoutOps",
                      platforms: [.macOS(.v10_10),
                                  .iOS(.v8),
                                  .tvOS(.v9)],
                      products: [.library(name: "LayoutOps",
                                          targets: ["LayoutOps"])],
                      targets: [.target(name: "LayoutOps",
                                        path: "Sources"),
                                .testTarget(
                                    name: "LayoutOpsTests",
                                    dependencies: ["LayoutOps"]),],
                      swiftLanguageVersions: [.v5])
