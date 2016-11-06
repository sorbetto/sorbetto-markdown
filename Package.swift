import PackageDescription

let package = Package(
    name: "SorbettoMarkdown",
    dependencies: [
        .Package(url: "../Sorbetto", majorVersion: 0),
        .Package(url: "https://github.com/vapor/markdown.git", majorVersion: 0, minor: 1),
    ]
)
