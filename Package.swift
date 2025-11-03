// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "DeskHUD",
    platforms: [ .macOS(.v13) ],
    products: [
        .executable(name: "DeskHUD", targets: ["DeskHUD"]),
    ],
    targets: [
        .executableTarget(
            name: "DeskHUD",
            path: "Sources/DeskHUD",
            resources: [
                .process("../Resources/Info.plist")
            ]
        )
    ]
)