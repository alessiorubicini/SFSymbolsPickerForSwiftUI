//
//  SwiftUIView.swift
//  
//
//  Created by Alessio Rubicini on 06/01/21.
//

import SwiftUI

struct UsageExample: View {
    
    @State private var name = ""
    @State private var icon = "l1.rectangle.roundedbottom"
    
    @State private var isPresented = false
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Write here", text: $name)
                
                Button(action: {
                    withAnimation {
                        isPresented.toggle()
                    }
                }, label: {
                    HStack {
                        Text("Choose an icon")
                        Spacer()
                        Image(systemName: icon)
                    }
                })
                
                SFSymbolsPicker(isPresented: $isPresented, icon: $icon, category: .games)
                
                
            }
            .navigationTitle("SFSymbolsPicker")
        }
    }
}

struct UsageExample_Previews: PreviewProvider {
    static var previews: some View {
        UsageExample()
    }
}
