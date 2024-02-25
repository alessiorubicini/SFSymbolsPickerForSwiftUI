//
//  SwiftUIView.swift
//  
//
//  Created by Alessio Rubicini on 06/01/21.
//

import SwiftUI

struct UsageExample: View {
    
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
                        SymbolsPicker(selection: $icon, title: "Choose your symbol", autoDismiss: true)
                    }).padding()
                    
            }
            .navigationTitle("SF Symbols Picker")
        }
    }
}

struct UsageExample_Previews: PreviewProvider {
    static var previews: some View {
        UsageExample()
    }
}
