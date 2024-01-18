// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftHit",
    defaultLocalization: "zh",
    platforms: [
        .iOS(.v15),
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
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.7.0")),
        .package(url: "https://github.com/bizz84/SwiftyStoreKit.git", .upToNextMajor(from: "0.16.4")),
        .package(url: "https://github.com/mxcl/PromiseKit.git", .upToNextMajor(from: "8.1.1")),
        .package(url: "https://github.com/Flight-School/AnyCodable", from: "0.6.7"),
        .package(url: "https://github.com/SwiftUIX/SwiftUIX.git", .upToNextMajor(from: "0.1.9"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "SwiftHit", dependencies: ["CoreHit", "UIHit"]),
        .testTarget(name: "SwiftHitTests", dependencies: ["SwiftHit"]),
        
        .target(name: "CoreHit", dependencies: ["AnyCodable"]),
        .testTarget(name: "CoreHitTests", dependencies: ["CoreHit"]),
        
        .target(name: "UIHit", dependencies: ["CoreHit",
                                              "SwiftUIX", "SwiftyStoreKit", "PromiseKit", "SnapKit"]),
        .testTarget(name: "UIHitTests", dependencies: ["UIHit"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
