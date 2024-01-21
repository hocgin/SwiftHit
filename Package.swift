// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftHit",
    defaultLocalization: "zh",
    platforms: [
        .iOS(.v16)
//        .macOS(.v12),
//        .tvOS(.v13),
//        .watchOS(.v6)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        // SwiftHit > UIHit > CoreHit
        .library(name: "SwiftHit", targets: ["SwiftHit"]),
        .library(name: "UIHit", targets: ["UIHit"]),
        .library(name: "CoreHit", targets: ["CoreHit"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.6.0"),
        .package(url: "https://github.com/bizz84/SwiftyStoreKit.git", from: "0.16.4"),
        .package(url: "https://github.com/hocgin/SmartCodable", from: "2.2.3"),
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.8.1"),
        .package(url: "https://github.com/BastiaanJansen/toast-swift", from: "2.1.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "SwiftHit", dependencies: [
            "CoreHit", "UIHit",
            "SwiftyStoreKit", "SnapKit", "Alamofire", "SmartCodable"
        ]),
        .testTarget(name: "SwiftHitTests", dependencies: ["SwiftHit"]),

        .target(name: "CoreHit", dependencies: []),
        .testTarget(name: "CoreHitTests", dependencies: ["CoreHit"]),

        .target(name: "UIHit", dependencies: []),
        .testTarget(name: "UIHitTests", dependencies: ["UIHit"])
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
