# SFSymbolsPicker

SFSymbolsPicker is a simple and powerful SwiftUI picker that let you pick Apple's SFSymbols inside your app with an easy binding!

## Example

```
@State private var name = ""
@State private var icon = "l1.rectangle.roundedbottom"

@State private var isPresented = false

var body: some View {
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
}
```

