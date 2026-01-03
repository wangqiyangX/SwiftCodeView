# SwiftCodeView

一个用于在 SwiftUI 中显示和语法高亮 Swift 代码的 Swift Package。

## 功能特性

- ✨ 基于 TreeSitter 的 Swift 代码语法高亮
- 🔤 等宽字体显示，提供良好的代码阅读体验
- ⚡ 实时语法高亮更新

## 安装

### Swift Package Manager

在 Xcode 中，选择 `File` > `Add Package Dependencies...`，然后输入以下 URL：

```text
https://github.com/wangqiyangx/SwiftCodeView.git
```

或者在你的 `Package.swift` 文件中添加依赖：

```swift
dependencies: [
    .package(url: "https://github.com/wangqiyangx/SwiftCodeView.git", branch: "main")
]
```

## 使用方法

### 基本用法

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

## 依赖项

- [SwiftTreeSitter](https://github.com/ChimeHQ/SwiftTreeSitter) - TreeSitter 的 Swift 绑定
- [tree-sitter-swift](https://github.com/alex-pinkus/tree-sitter-swift) - Swift 语言的 TreeSitter 解析器

## 系统要求

- iOS 18.0+
- macOS 18.0+
- Swift 6.2+

## 许可证

## 贡献

欢迎提交 Issue 和 Pull Request！
