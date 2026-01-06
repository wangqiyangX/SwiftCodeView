//
//  File.swift
//  SwiftCodeView
//
//  Created by wangqiyang on 2025/9/26.
//

import Foundation
import SwiftTreeSitter
import SwiftUI
import TreeSitterSwift

struct SyntaxHighlightingTheme {
    let plain: Color
    let attribute: Color
    let comment: Color
    let spell: Color
    let keyword: Color
    let number: Color
    let string: Color
    let function: Color
    let type: Color
    let variable: Color
    let `operator`: Color
    let punctuation: Color

    static let `default` = SyntaxHighlightingTheme(
        plain: Color.primary,
        attribute: Color.brown,
        comment: Color.secondary,
        spell: Color.secondary,
        keyword: Color.green,
        number: Color.yellow,
        string: Color.orange,
        function: Color.purple,
        type: Color.red,
        variable: Color.blue,
        operator: Color.primary,
        punctuation: Color.primary
    )
}

@Observable
public final class SwiftCodeViewModel {
    var config: LanguageConfiguration?
    var parser: Parser
    var attributedText: AttributedString = ""
    var theme: SyntaxHighlightingTheme = .default
    var showLineNumbers: Bool = true
    private var bundledHighlightsQuery: Query?

    public init() {
        self.parser = Parser()
        setupLanguageConfiguration()
    }

    private func setupLanguageConfiguration() {
        do {
            self.config = try LanguageConfiguration(
                tree_sitter_swift(),
                name: "Swift"
            )
            if let language = config?.language {
                try self.parser.setLanguage(language)
            }
        } catch {
            // Fall back to setting the language directly without queries.
            // This avoids Xcode Previews sandbox path issues for bundled query files.
            _ = try? self.parser.setLanguage(tree_sitter_swift())
            self.config = nil
        }
    }

    private func setupBundledQueriesIfNeeded() {
        guard bundledHighlightsQuery == nil else { return }
        // Try loading highlights.scm from the SwiftPM module bundle
        guard
            let url = Bundle.main
                .resourceURL?
                .appendingPathComponent(
                    "TreeSitterSwift_TreeSitterSwift.bundle"
                )
                .appendingPathComponent(
                    "Contents/Resources/queries/highlights.scm"
                )
        else {
            return
        }
        do {
            if let language = config?.language {
                bundledHighlightsQuery = try language.query(contentsOf: url)
            } else {
                let lang = SwiftTreeSitter.Language(tree_sitter_swift())
                bundledHighlightsQuery = try lang.query(contentsOf: url)
            }
        } catch {
            bundledHighlightsQuery = nil
        }
    }

    func highlight(code: String) {
        guard let config = config,
            let tree = parser.parse(code)
        else {
            attributedText = AttributedString(code)
            return
        }

        var result = AttributedString(code)

        // Apply syntax highlighting
        let query = config.queries[.highlights]!
        let cursor = query.execute(in: tree)
        let highlights =
            cursor
            .resolve(with: .init(string: code))
            .highlights()

        // Sort highlights by start position
        let sortedHighlights = highlights.sorted {
            $0.range.lowerBound < $1.range.lowerBound
        }

        // Apply highlighting to attributed string
        for highlight in sortedHighlights {
            let range = Range(highlight.range, in: result)!
            let color = colorForHighlight(highlight.name)

            result[range].foregroundColor = color
            result[range].font = .system(.body, design: .monospaced)
        }

        // Apply default styling to unhighlighted text
        // Only set font globally, not foregroundColor to avoid overriding highlights
        result.font = .system(.body, design: .monospaced)

        // Apply default text color only to ranges that don't have highlighting
        if let query = config.queries[.highlights] {
            let cursor = query.execute(in: tree)
            let highlights = cursor.resolve(with: .init(string: code))
                .highlights()
            let highlightedRanges = highlights.map {
                Range($0.range, in: result)!
            }

            // Find unhighlighted ranges and apply default color
            var currentIndex = result.startIndex
            for range in highlightedRanges.sorted(by: {
                $0.lowerBound < $1.lowerBound
            }) {
                if currentIndex < range.lowerBound {
                    let unhighlightedRange = currentIndex..<range.lowerBound
                    result[unhighlightedRange].foregroundColor = theme.plain
                }
                currentIndex = range.upperBound
            }

            // Apply default color to remaining unhighlighted text
            if currentIndex < result.endIndex {
                let remainingRange = currentIndex..<result.endIndex
                result[remainingRange].foregroundColor = theme.plain
            }
        } else {
            // If no highlighting available, apply default color to entire text
            result.foregroundColor = theme.plain
        }

        attributedText = result
    }

    private func colorForHighlight(_ highlightName: String) -> Color {
        switch highlightName {
        case "comment.documentation":
            return theme.comment
        case "spell":
            return theme.spell
        case "variable", "variable.parameter":
            return theme.variable
        case "attribute":
            return theme.attribute
        case "keyword", "keyword.import", "keyword.modifier",
            "keyword.function", "keyword.conditional":
            return theme.keyword
        case "string", "string.escape":
            return theme.string
        case "function.call":
            return theme.function
        case "type":
            return theme.type
        case "number":
            return theme.number
        case "operator":
            return theme.operator
        case "punctuation", "punctuation.delimiter":
            return theme.punctuation
        default:
            return theme.plain
        }
    }
}
