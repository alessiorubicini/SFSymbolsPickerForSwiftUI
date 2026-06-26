import SwiftUI

public struct SymbolsPickerGridConfiguration {
    public var minimumSize: CGFloat
    public var maximumSize: CGFloat
    public var spacing: CGFloat
    
    public init(minimumSize: CGFloat = 60, maximumSize: CGFloat = 80, spacing: CGFloat = 8) {
        self.minimumSize = minimumSize
        self.maximumSize = maximumSize
        self.spacing = spacing
    }
}

public struct SymbolsPickerColorConfiguration {
    public var selectedIconColor: Color
    public var unselectedIconColor: Color
    public var selectedBackgroundColor: Color
    public var unselectedBackgroundColor: Color
    
    public init(
        selectedIconColor: Color = .accentColor,
        unselectedIconColor: Color = .primary,
        selectedBackgroundColor: Color = Color.accentColor.opacity(0.15),
        unselectedBackgroundColor: Color = .clear
    ) {
        self.selectedIconColor = selectedIconColor
        self.unselectedIconColor = unselectedIconColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.unselectedBackgroundColor = unselectedBackgroundColor
    }
}

private struct SymbolsPickerGridKey: EnvironmentKey {
    static let defaultValue = SymbolsPickerGridConfiguration()
}

private struct SymbolsPickerColorKey: EnvironmentKey {
    static let defaultValue = SymbolsPickerColorConfiguration()
}

public extension EnvironmentValues {
    var symbolsPickerGrid: SymbolsPickerGridConfiguration {
        get { self[SymbolsPickerGridKey.self] }
        set { self[SymbolsPickerGridKey.self] = newValue }
    }
    
    var symbolsPickerColors: SymbolsPickerColorConfiguration {
        get { self[SymbolsPickerColorKey.self] }
        set { self[SymbolsPickerColorKey.self] = newValue }
    }
}

public extension View {
    /// Configures the grid layout for `SymbolsPicker`
    func symbolsPickerGrid(minimumSize: CGFloat = 60, maximumSize: CGFloat = 80, spacing: CGFloat = 8) -> some View {
        self.environment(\.symbolsPickerGrid, SymbolsPickerGridConfiguration(minimumSize: minimumSize, maximumSize: maximumSize, spacing: spacing))
    }
    
    /// Configures the icon and background colors for `SymbolsPicker`
    func symbolsPickerColors(
        selectedIconColor: Color = .accentColor,
        unselectedIconColor: Color = .primary,
        selectedBackgroundColor: Color = Color.accentColor.opacity(0.15),
        unselectedBackgroundColor: Color = .clear
    ) -> some View {
        self.environment(\.symbolsPickerColors, SymbolsPickerColorConfiguration(
            selectedIconColor: selectedIconColor,
            unselectedIconColor: unselectedIconColor,
            selectedBackgroundColor: selectedBackgroundColor,
            unselectedBackgroundColor: unselectedBackgroundColor
        ))
    }
}
