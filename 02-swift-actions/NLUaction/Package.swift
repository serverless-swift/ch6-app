// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Action",
    products: [
    .executable(
        name: "Action",
        targets:  ["Action"]
    )
    ],
    dependencies: [
    .package(url: "https://github.com/IBM-Swift/SwiftyRequest.git", .upToNextMajor(from: "2.0.0")),
    .package(url: "https://github.com/watson-developer-cloud/swift-sdk", from: "3.4.0")
    ],
    targets: [
    .target(
        name: "Action",
        dependencies: ["SwiftyRequest","NaturalLanguageUnderstandingV1","LanguageTranslatorV3"],
        path: "."
    )
    ]
)
