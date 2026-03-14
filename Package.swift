// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "VocabularyCorrector",
    products: [
        .library(name: "VocabularyCorrector", targets: ["VocabularyCorrector"]),
    ],
    targets: [
        .target(
            name: "VocabularyCorrector",
            path: "Sources/VocabularyCorrector"
        ),
        .testTarget(
            name: "VocabularyCorrectorTests",
            dependencies: ["VocabularyCorrector"],
            path: "Tests/VocabularyCorrectorTests"
        ),
    ]
)
