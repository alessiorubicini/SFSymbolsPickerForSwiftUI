//
//  SwiftUIView.swift
//
//
//  Created by Alessio Rubicini on 22/10/23.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {            
            
            TextField("Search...", text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.searchText = ""
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

#Preview {
    SearchBar(searchText: .constant(""))
}
