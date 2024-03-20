# SF Symbols Picker

SFSymbolsPicker is a simple and powerful SwiftUI picker that let you pick Apple's SF Symbols inside your iOS and macOS apps with an easy binding!

![SF Symbols Picker](./Resources/SFSymbolsPicker.png)

## Changelog
### 1.0.5
- Optimized symbol loading performances
- Improved search bar

### 1.0.4
- Fixed visibility bug for SymbolPicker view

### 1.0.3
- Added the ability to automatically dismiss the view when a symbol is selected
- Added the ability to specify the view title and a label for the search bar
- Added a toolbar icon to manually dismiss the view

### 1.0.2

The way the package loads SF symbols has radically changed. Now the symbols are read at run-time directly by the system, so the users can access the latest symbols added by Apple as soon as they update their devices. Special thanks to [mackoj](https://github.com/mackoj) for the suggestion in implementing this solution.

## Usage

Here's a short usage example. You can find the full code in [UsageExample.swift](https://github.com/alessiorubicini/SFSymbolsPickerForSwiftUI/blob/master/Sources/SFSymbolsPicker/UsageExample.swift).

```swift
@State private var icon = "star.fill"
@State private var isPresented = false
    
var body: some View {
    NavigationView {
        VStack {
            Button("Select a symbol") {
                isPresented.toggle()
            }

            Image(systemName: icon).font(.title3)

                .sheet(isPresented: $isPresented, content: {
                    SymbolsPicker(selection: $icon, title: "Pick a symbol", autoDismiss: true)
                }).padding()

        }
        .navigationTitle("SF Symbols Picker")
    }
}
```

## Installation

Required:
- iOS 14.0 or above
- macOS 11.0 or above
- Xcode 12.0 or above

In Xcode go to `File -> Add Package Dependencies...` and paste in the repo's url: `https://github.com/alessiorubicini/SFSymbolsPicker`.
Then choose the main branch or the version you desire.

## License

Copyright 2024 (©) Alessio Rubicini.

The license for this repository is MIT License.

Please see the [LICENSE](LICENSE) file for full reference
