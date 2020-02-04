// swift-tools-version:5.0

import PackageDescription

let package = Package(
        name: "AndroidSwiftTrace",
        products: [
            .library(name: "AndroidSwiftTrace", targets: ["trace"])
        ],
        targets:[
            .systemLibrary(name: "trace", path: "Sources"),
        ]
)
