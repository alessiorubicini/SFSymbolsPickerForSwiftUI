//
//  SwiftUIView.swift
//
//
//  Created by Alessio Rubicini on 22/10/23.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    let label: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {            
            
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField(label, text: $searchText)
                
                if(!searchText.isEmpty) {
                    Button(action: {
                        searchText = ""
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                    })
                }
            }
                .padding(.vertical, 8)
                .padding(.leading, 10)
                .padding(.trailing, 15)
                .foregroundColor(.secondary)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 5)
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
    SearchBar(searchText: .constant(""), label: "Search...")
}
