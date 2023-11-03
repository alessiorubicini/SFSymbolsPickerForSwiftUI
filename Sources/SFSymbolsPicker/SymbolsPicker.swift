//
//  SwiftUIView.swift
//  
//
//  Created by Alessio Rubicini on 22/10/23.
//

import SwiftUI

public struct SymbolsPicker: View {
    
    // MARK: - View properties
    
    @Binding var selection: String
    let title: String
    let searchbarLabel: String
    let autoDismiss: Bool
    
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @State private var isFirstTimeAppeared = false
    @State private var symbols: [String] = []
    
    /// Initialize the SymbolsPicker view
    /// - Parameters:
    ///   - selection: binding to the selected icon name.
    ///   - title: navigation title for the view.
    ///   - searchLabel: label for the search bar. Set to 'Search...' by default.
    ///   - autoDismiss: if true the view automatically dismisses itself when the symbols is selected.
    public init(selection: Binding<String>, title: String, searchLabel: String = "Search...", autoDismiss: Bool = false) {
        self._selection = selection
        self.title = title
        self.searchbarLabel = searchLabel
        self.autoDismiss = autoDismiss
    }
    
    // MARK: - View body
    
    public var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $searchText, label: searchbarLabel)
                
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
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "xmark.circle")
                        }

                    }
                }
                .padding(.vertical, 5)
                
            }.padding(.horizontal, 5)
        }
        
        .onChange(of: selection) { newValue in
            if(autoDismiss) {
                presentationMode.wrappedValue.dismiss()
            }
        }
        
        .onAppear {
            if(!isFirstTimeAppeared) {
                self.symbols = SymbolLoader.loadSymbolsFromSystem()
            }
        }
        
    }

}

#Preview {
    SymbolsPicker(selection: .constant("beats.powerbeatspro"), title: "Pick a symbol", autoDismiss: true)
}
