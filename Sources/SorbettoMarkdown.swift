import Foundation
import PathKit
import Sorbetto
import cmark_swift

extension Path {
    var isMarkdownFile: Bool {
        guard let ext = `extension` else {
            return false
        }

        return ext.compare("md", options: .caseInsensitive) == .orderedSame || ext.compare("markdown", options: .caseInsensitive) == .orderedSame
    }
}

public struct Markdown: Plugin {
    public enum Error: Swift.Error {
        case badEncoding
        case conversionFailed
    }

    public init() {}

    public func run(site: Site) throws {
        for path in site.paths where path.isMarkdownFile {
            guard let file = site[path] else {
                continue
            }

            guard let contents = String(data: file.contents, encoding: .utf8) else {
                throw Error.badEncoding
            }

            guard let htmlContents = try? markdownToHTML(contents) else {
                throw Error.conversionFailed
            }

            guard let htmlData = htmlContents.data(using: .utf8) else {
                throw Error.badEncoding
            }

            file.contents = htmlData

            let newFilename = path.lastComponentWithoutExtension + ".html"
            let newPath = path + ".." + newFilename
            site[newPath] = file
            site[path] = nil
        }
    }
}
