//
//  CustomSymbolsExample.swift
//  SFSymbolsPicker
//
//  Created by Alessio Rubicini on 01/11/25.
//

import Foundation
import SwiftUI

/// Example view demonstrating the usage of SymbolsPicker with a custom set of symbols.
struct CustomSymbolsExample: View {
    
    @State private var isSheetPresented = false
    @State private var icon = "figure.walk"
    @State private var iconSize: CGFloat = 50
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Selected Symbol Preview
                VStack(spacing: 16) {
                    Image(systemName: icon)
                        .font(.system(size: iconSize))
                        .foregroundColor(.accentColor)
                        .frame(width: 100, height: 100)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.accentColor.opacity(0.1))
                        )
                    
                    Text(icon)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                // Open Picker Button
                Button {
                    isSheetPresented.toggle()
                } label: {
                    HStack {
                        Image(systemName: "square.grid.2x2")
                        Text(verbatim: "Choose Symbol")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(15)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("SF Symbols Picker")
            .sheet(isPresented: $isSheetPresented) {
                SymbolsPicker(
                    selection: $icon,
                    title: "Choose your symbol",
                    searchLabel: "Search symbols...",
                    autoDismiss: true,
                    symbols: [.figureWalk, .figureWalkCircle, .figureWalkCircleFill, .figureWave, .figureWaveCircle, .figureWaveCircleFill]
                ) {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
}

#Preview {
    CustomSymbolsExample()
}
