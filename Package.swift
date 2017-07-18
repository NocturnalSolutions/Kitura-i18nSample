// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "KituraI18nSample",
    dependencies: [
        .Package(url: "https://github.com/NocturnalSolutions/Kitura-Translation.git", majorVersion: 0),
        .Package(url: "https://github.com/NocturnalSolutions/Kitura-LanguageNegotiation.git", majorVersion: 0)
    ]
)
