# SwiftCodeView

A Swift Package for displaying and syntax highlighting Swift code in SwiftUI.

## Features

- ✨ Swift code syntax highlighting based on TreeSitter
- 🔤 Monospaced font display for better code reading experience
- ⚡ Real-time syntax highlighting updates

## Installation

### Swift Package Manager

In Xcode, select `File` > `Add Package Dependencies...`, then enter the following URL:

```text
https://github.com/wangqiyangx/SwiftCodeView.git
```

Or add the dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/wangqiyangx/SwiftCodeView.git", branch: "main")
]
```

## Usage

### Basic Usage

```swift
import SwiftUI
import SwiftCodeView

struct ContentView: View {
    var body: some View {
        SwiftCodeView(
            """
            func greet(name: String) {
                print("Hello, \\(name)!")
            }
            """
        )
    }
}
```

## Dependencies

- [SwiftTreeSitter](https://github.com/ChimeHQ/SwiftTreeSitter) - Swift bindings for TreeSitter
- [tree-sitter-swift](https://github.com/alex-pinkus/tree-sitter-swift) - TreeSitter parser for Swift language

## Requirements

- iOS 18.0+
- macOS 18.0+
- Swift 6.2+

## License

## Contributing

Issues and Pull Requests are welcome!
