// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkFlowStudy",
    platforms: [.macOS(.v10_15)],
    products: [
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Basic"),
        .target(
            name: "Graphviz",
            dependencies: []),
        .target(
            name: "EdmondsKarp",
            dependencies: ["Basic", "Graphviz"]),
        .target(
            name: "Dinic",
            dependencies: ["Basic", "EdmondsKarp"]),
        .testTarget(
            name: "NetworkFlowStudyTests",
            dependencies: ["EdmondsKarp", "Dinic"]),
    ]
)
