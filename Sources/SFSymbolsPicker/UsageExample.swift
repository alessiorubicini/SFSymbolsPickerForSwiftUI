//
//  SwiftUIView.swift
//  
//
//  Created by Alessio Rubicini on 06/01/21.
//

import SwiftUI

struct UsageExample: View {
    
    @State private var icon = "l1.rectangle.roundedbottom"
    
    @State private var isPresented = false
    
    var body: some View {
        NavigationView {
            Form {
                Text("Developed by Alessio Rubicini")
                
                Button(action: {
                    withAnimation {
                        isPresented.toggle()
                    }
                }, label: {
                    HStack {
                        Text("Press here")
                        Spacer()
                        Image(systemName: icon).font(.title3)
                    }
                })
                
                SFSymbolsPicker(isPresented: $isPresented, icon: $icon, category: .games, axis: .vertical, haptic: true)
                    
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
