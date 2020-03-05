// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkFlowStudy",
    products: [
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Graphviz",
            dependencies: []),
        .target(
            name: "EdmondsKarp",
            dependencies: ["Graphviz"]),
        .testTarget(
            name: "NetworkFlowStudyTests",
            dependencies: ["EdmondsKarp"]),
    ]
)
