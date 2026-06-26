//
//  SwiftUIView.swift
//
//
//  Created by Alessio Rubicini on 22/10/23.
//

import SwiftUI

struct SymbolIcon: View {
    
    let symbolName: String
    @Binding var selection: String
    @Environment(\.symbolsPickerColors) var colorConfig
    
    private let size: CGFloat = 44
    private let cornerRadius: CGFloat = 8
    @State private var isPressed: Bool = false
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selection = symbolName
            }
        } label: {
            Image(systemName: symbolName)
                .font(.system(size: 24, weight: .regular))
                .frame(width: size, height: size)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(selection == symbolName ? 
                            colorConfig.selectedBackgroundColor : 
                            colorConfig.unselectedBackgroundColor)
                )
                .foregroundStyle(selection == symbolName ? 
                    colorConfig.selectedIconColor : 
                    colorConfig.unselectedIconColor)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
                .accessibilityLabel(Text(symbolName.replacingOccurrences(of: ".", with: " ")))
        }
        .buttonStyle(SymbolButtonStyle(isPressed: $isPressed))
        .contentShape(Rectangle())
    }
    
}

private struct SymbolButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { oldValue, newValue in
                isPressed = newValue
            }
    }
}

#Preview {
    SymbolIcon(symbolName: "beats.powerbeatspro", selection: .constant("star.bubble"))
}
