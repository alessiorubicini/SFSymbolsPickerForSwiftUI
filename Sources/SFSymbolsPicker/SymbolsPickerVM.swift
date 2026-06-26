//
//  SymbolsPickerViewModel.swift
//
//
//  Created by Alessio Rubicini on 25/02/24.
//

import Foundation
import SwiftUI
import SFSafeSymbols
import Observation

@MainActor
@Observable
public class SymbolsPickerViewModel {
    
    let title: Text
    let searchbarLabel: Text
    let autoDismiss: Bool
    private let symbolLoader: SymbolLoader = SymbolLoader()
    private var searchTask: Task<Void, Never>?
    private let customSymbols: [String]
    private let useCustomSymbols: Bool

    var symbols: [String] = []
    var isLoading: Bool = true
    var isLoadingMore: Bool = false
    private var isSearching: Bool = false

    init(title: Text, searchbarLabel: Text, autoDismiss: Bool, symbols: [SFSymbol] = []) {
        self.title = title
        self.searchbarLabel = searchbarLabel
        self.autoDismiss = autoDismiss
        
        if !symbols.isEmpty {
            self.customSymbols = symbols.map { $0.rawValue }
            self.useCustomSymbols = true
            self.symbols = self.customSymbols
            self.isLoading = false
        } else {
            self.customSymbols = []
            self.useCustomSymbols = false
            Task {
                await self.loadSymbols()
            }
        }
    }

    public var hasMoreSymbols: Bool {
        guard !useCustomSymbols else { return false }
        return !isSearching && symbolLoader.hasMoreSymbols()
    }

    public func loadSymbols() async {
        self.isLoading = true
        let loaded = await self.symbolLoader.getSymbols()
        self.symbols = loaded
        self.isLoading = false
    }

    public func loadMoreSymbols() {
        guard !useCustomSymbols && !isLoadingMore && hasMoreSymbols else { return }
        isLoadingMore = true
        
        let newSymbols = self.symbolLoader.loadNextPage()
        if !newSymbols.isEmpty {
            self.symbols.append(contentsOf: newSymbols)
        }
        self.isLoadingMore = false
    }

    public func searchSymbols(with name: String) {
        searchTask?.cancel()
        
        searchTask = Task {
            do {
                try await Task.sleep(nanoseconds: 300_000_000) // 300ms debounce
            } catch {
                return
            }
            guard !Task.isCancelled else { return }
            
            isSearching = true
            self.isLoading = true
            
            if self.useCustomSymbols {
                let filtered = self.customSymbols.filter { symbol in
                    symbol.lowercased().contains(name.lowercased())
                }
                self.symbols = filtered
            } else {
                let searched = await self.symbolLoader.getSymbols(named: name)
                guard !Task.isCancelled else { return }
                self.symbols = searched
            }
            self.isLoading = false
        }
    }

    public func reset() {
        if useCustomSymbols {
            symbols = customSymbols
            isSearching = false
            isLoading = false
            searchTask?.cancel()
        } else {
            symbolLoader.resetPagination()
            symbols.removeAll()
            isLoading = true
            isSearching = false
            isLoadingMore = false
            searchTask?.cancel()
            Task {
                await loadSymbols()
            }
        }
    }
}
