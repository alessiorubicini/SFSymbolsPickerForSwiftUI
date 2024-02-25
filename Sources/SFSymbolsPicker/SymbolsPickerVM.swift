//
//  SymbolsPickerViewModel.swift
//
//
//  Created by Alessio Rubicini on 25/02/24.
//

import Foundation
import SwiftUI

public class SymbolsPickerViewModel: ObservableObject {
    
    let title: String
    let searchbarLabel: String
    let autoDismiss: Bool
    private let symbolLoader: SymbolLoader = SymbolLoader()
    
    @Published var symbols: [String] = []
    
    init(title: String, searchbarLabel: String, autoDismiss: Bool) {
        self.title = title
        self.searchbarLabel = searchbarLabel
        self.autoDismiss = autoDismiss
        self.symbols = []
        self.loadSymbols()
    }
    
    public var hasMoreSymbols: Bool {
        return symbolLoader.hasMoreSymbols()
    }
    
    public func loadSymbols() {
        if(symbolLoader.hasMoreSymbols()) {
            withAnimation {
                symbols = symbols + symbolLoader.getSymbols()
            }
        }
    }
    
    public func searchSymbols(with name: String) {
        withAnimation {
            symbols = symbolLoader.getSymbols(named: name)
        }
    }
    
    public func reset() {
        symbolLoader.resetPagination()
        symbols.removeAll()
        loadSymbols()
    }
    

}
