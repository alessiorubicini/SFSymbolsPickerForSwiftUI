//
//  SwiftUIView.swift
//  
//
//  Created by Alessio Rubicini on 22/10/23.
//

import SwiftUI

struct SymbolsPicker: View {
    
    // MARK: - View properties
        
    @Environment(\.presentationMode) var presentationMode
    @Binding var selection: String
    @State private var searchText = ""
    @State private var isFirstTimeAppeared = false
    @State private var symbols: [String] = []
    
    
    
    // MARK: - View body
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $searchText)
                
                ScrollView(.vertical) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 20) {
                        ForEach(symbols.filter{searchText.isEmpty ? true : $0.contains(searchText.lowercased()) }, id: \.hash) { icon in
                            
                            Button {
                                withAnimation {
                                    self.selection = icon
                                }
                            } label: {
                                SymbolIcon(icon: icon, selection: $selection)
                            }

                        }.padding(.top, 5)
                    }
                }
                .navigationTitle("Pick a symbol")
                .navigationBarTitleDisplayMode(.inline)
                .padding(.vertical, 5)
                
            }.padding(.horizontal, 5)
        }
        .onAppear {
            if(!isFirstTimeAppeared) {
                self.loadSymbolsFromSystem()
            }
        }
    }
    
    private func loadSymbolsFromSystem() {
        var symbols = [String]()
        if let bundle = Bundle(identifier: "com.apple.CoreGlyphs"),
           let resourcePath = bundle.path(forResource: "name_availability", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: resourcePath),
           let plistSymbols = plist["symbols"] as? [String: String]
        {
            symbols = Array(plistSymbols.keys)
        }
        self.symbols = symbols
    }

}

#Preview {
    SymbolsPicker(selection: .constant("beats.powerbeatspro"))
}
