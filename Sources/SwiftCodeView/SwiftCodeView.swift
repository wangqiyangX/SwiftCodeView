//
//  SwiftCodeView.swift
//  SwiftCodeView
//
//  A SwiftUI view component for displaying and syntax highlighting Swift code.
//

import SwiftUI

/// A SwiftUI view that displays Swift code with syntax highlighting.
///
/// This view uses TreeSitter to parse and highlight Swift code, providing
/// color-coded syntax highlighting for keywords, strings, numbers, functions,
/// types, and other code elements.
///
/// Example usage:
/// ```swift
/// SwiftCodeView(
///     """
///     func greet(name: String) {
///         print("Hello, \\(name)!")
///     }
///     """
/// )
/// ```
public struct SwiftCodeView: View {
    /// The Swift code string to display and highlight.
    let codeString: String

    /// The view model that handles syntax highlighting logic.
    @State private var viewModel = SwiftCodeViewModel()

    /// Creates a new SwiftCodeView with the given code string.
    ///
    /// - Parameter codeString: The Swift code to display and highlight.
    public init(_ codeString: String) {
        self.codeString = codeString
    }

    public var body: some View {
        Text(viewModel.attributedText)
            .onAppear {
                // Perform initial syntax highlighting when the view appears
                viewModel.highlight(code: codeString)
            }
            .onChange(of: codeString) { _, newCode in
                // Update syntax highlighting when the code string changes
                viewModel.highlight(code: newCode)
            }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SwiftCodeView(
            """
            /// Comments
            // MARK: - Marks
            let ss = ""
            """
        )
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 12))
    }
}
