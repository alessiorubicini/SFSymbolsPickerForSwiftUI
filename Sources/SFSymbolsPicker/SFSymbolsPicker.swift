//
//  SFSymbolsPicker.swift
//
//
//  Created by Alessio Rubicini on 05/01/21.
//

import SwiftUI


public struct SFSymbolsPicker: View {
    
    @Binding var isPresented: Bool
    @Binding var icon: String
    let category: Category
    
    public var body: some View {
        ScrollView(.vertical) {
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 20) {
                
                ForEach(symbols[category.rawValue]!, id: \.hash) { icon in
                    
                    Image(systemName: icon)
                        .font(.system(size: 25))
                        .animation(.linear)
                        
                        .onTapGesture {
                            self.icon = icon
                        }
                    
                }.padding(.top, 5)
            }
        }
            
    }
}

public enum Category: String, CaseIterable, Identifiable {
    public var id: String { rawValue }
    
    case communication = "Communication"
    case weather = "Weather"
    case objects = "Objects"
    case devices = "Devices"
    case games = "Games"
    case connectivity = "Connectivity"
    case transport = "Transport"
    case people = "People"
    case nature = "Nature"
    case edit = "Edit"
    case text = "Text"
    case multimedia = "Multimedia"
    case keyboard = "Keyboard"
    case commerce = "Commerce"
    case time = "Time"
    case health = "Health"
    case forms = "Forms"
    case arrows = "Arrows"
    case indices = "Indices"
    case math = "Math"
    
    case none = ""
}

struct SFSymbolsPicker_Previews: PreviewProvider {
    
    static var previews: some View {
        
        VStack {
            
            
            SFSymbolsPicker(isPresented: .constant(false), icon: .constant(""), category: .commerce)
        }
    }
}
