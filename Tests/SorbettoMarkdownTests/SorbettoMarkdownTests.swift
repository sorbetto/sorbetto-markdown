import PathKit
import Sorbetto
import XCTest
@testable import SorbettoMarkdown

class SorbettoMarkdownTests: XCTestCase {
    @discardableResult
    func buildTest(path: String) throws -> Site {
        let destination = try Path.uniqueTemporary()

        //
        // Why three ".."?
        //        <-(1) <-(2)         <-(3)
        // Sorbetto/Tests/SorbettoTests/X.swift
        //
        let fileToRoot = "../../.."

        let repoRoot = (Path(#file) + fileToRoot).normalize()
        let directoryPath = repoRoot + path
        XCTAssertTrue(directoryPath.isDirectory)

        return try Sorbetto(directory: directoryPath, destination: destination)
            .using(Markdown())
            .build()
    }

    func testFixtures1() throws {
        let site = try buildTest(path: "./Fixtures/Sites/01/")

        XCTAssertNil(site["index.md"], "Should have moved index.md to index.html")

        guard let index = site["index.html"] else {
            XCTFail("index.html should exist")
            return
        }

        XCTAssertEqual(index.contents, "<h1>Hello, Sorbetto!</h1>\n".data(using: .utf8))
    }

    static var allTests : [(String, (SorbettoMarkdownTests) -> () throws -> Void)] {
        return [
            ("testFixtures1", testFixtures1),
        ]
    }
}
