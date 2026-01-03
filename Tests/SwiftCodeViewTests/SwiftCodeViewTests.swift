import Testing

@testable import SwiftCodeView

@Test func example() async throws {
    let viewModel = SwiftCodeViewModel()
    viewModel.highlight(
        code:
            """
            func main() {}
            """
    )
}
