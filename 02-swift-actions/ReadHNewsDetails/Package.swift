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
    .package(url: "https://github.com/cloudant/swift-cloudant.git", from: "0.9.1"),
    .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "4.2.0"),
    .package(url: "https://github.com/IBM-Swift/Kitura-net.git", from: "2.4.0")
    ],
    targets: [
    .target(
        name: "Action",
        dependencies: ["SwiftCloudant","SwiftyJSON","KituraNet"],
        path: "."
    )
    ]
)
