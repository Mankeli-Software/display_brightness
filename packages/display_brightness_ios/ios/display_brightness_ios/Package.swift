// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "display_brightness_ios",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "display-brightness-ios", targets: ["display_brightness_ios", "display_brightness_ios_objc"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "display_brightness_ios",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            path: "Sources/display_brightness",
            exclude: ["display_brightness.m"]
        ),
        .target(
            name: "display_brightness_ios_objc",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            path: "Sources/display_brightness",
            exclude: ["DisplayBrightness.swift"],
            publicHeadersPath: "."
        )
    ]
)
