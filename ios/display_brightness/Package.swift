// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "display_brightness",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "display-brightness", targets: ["display_brightness", "display_brightness_objc"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "display_brightness",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            path: "Sources/display_brightness",
            exclude: ["display_brightness.m"]
        ),
        .target(
            name: "display_brightness_objc",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            path: "Sources/display_brightness",
            exclude: ["DisplayBrightness.swift"],
            publicHeadersPath: "."
        )
    ]
)
