import SwiftUI

public struct SwiftCodeView: View {
    let code: String

    @State private var viewModel = SwiftCodeViewModel()

    public init(code: String) {
        self.code = code
    }

    public var body: some View {
        Text(viewModel.attributedText)
            .onAppear {
                viewModel.highlight(code: code)
            }
            .onChange(of: code) { _, newCode in
                viewModel.highlight(code: newCode)
            }
            .scrollIndicators(.hidden)
            .padding()
            .visionGlassIfAvailable()
    }
}

extension View {
    @ViewBuilder
    fileprivate func visionGlassIfAvailable() -> some View {
        #if canImport(SwiftUI)
            if #available(iOS 26, *)
            {
                self.glassEffect(.regular, in: .rect(cornerRadius: 10))
            } else {
                self
            }
        #else
            self
        #endif
    }
}

#Preview {
    NavigationStack {
        SwiftCodeView(
            code:
                """
                // Comments
                // MARK: - Marks
                @State private var value: Double = 10
                @State private var code: String = "Hello, world!"
                """
        )
    }
}
