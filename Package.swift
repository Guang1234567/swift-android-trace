// swift-tools-version:5.0

import PackageDescription

let package = Package(
        name: "AndroidSwiftTrace",
        products: [
            .library(name: "AndroidSwiftTrace", targets: ["AndroidSwiftTrace"]),
        ],
        dependencies: [
            .package(url: "https://github.com/Guang1234567/swift-android-logcat.git", .branch("master")),
        ],
        targets:[
            .systemLibrary(name: "CAndroidSwiftTrace"),
            .target(name: "AndroidSwiftTrace", dependencies: ["CAndroidSwiftTrace", "AndroidSwiftLogcat",]),
        ]
)
