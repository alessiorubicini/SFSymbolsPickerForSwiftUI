//
//  SymbolsPickerViewModel.swift
//
//
//  Created by Alessio Rubicini on 25/02/24.
//

import Foundation
import SwiftUI
import SFSafeSymbols

public class SymbolsPickerViewModel: ObservableObject {
    
    let title: Text
    let searchbarLabel: Text
    let autoDismiss: Bool
    private let symbolLoader: SymbolLoader = SymbolLoader()
    private var searchTask: Task<Void, Never>?
    private let customSymbols: [String]
    private let useCustomSymbols: Bool

    @Published var symbols: [String] = []
    @Published var isLoading: Bool = true
    @Published var isLoadingMore: Bool = false
    private var isSearching: Bool = false

    init(title: Text, searchbarLabel: Text, autoDismiss: Bool, symbols: [SFSymbol] = []) {
        self.title = title
        self.searchbarLabel = searchbarLabel
        self.autoDismiss = autoDismiss
        
        // Convert SFSymbol array to string array if provided
        if !symbols.isEmpty {
            self.customSymbols = symbols.map { $0.rawValue }
            self.useCustomSymbols = true
            // Set symbols directly without loading
            DispatchQueue.main.async {
                self.symbols = self.customSymbols
                self.isLoading = false
            }
        } else {
            self.customSymbols = []
            self.useCustomSymbols = false
            NotificationCenter.default.addObserver(self, selector: #selector(updateSymbols), name: .symbolsLoaded, object: nil)
            self.loadSymbols()
        }
    }

    @objc private func updateSymbols() {
        DispatchQueue.main.async {
            self.symbols = self.symbolLoader.getSymbols()
            self.isLoading = false
        }
    }

    public var hasMoreSymbols: Bool {
        guard !useCustomSymbols else { return false }
        return !isSearching && symbolLoader.hasMoreSymbols()
    }

    public func loadSymbols() {
        DispatchQueue.main.async {
            self.symbols = self.symbolLoader.getSymbols()
            self.isLoading = false
        }
    }

    public func loadMoreSymbols() {
        guard !useCustomSymbols && !isLoadingMore && hasMoreSymbols else { return }
        isLoadingMore = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let newSymbols = self.symbolLoader.loadNextPage()
            
            DispatchQueue.main.async {
                if !newSymbols.isEmpty {
                    self.symbols = self.symbolLoader.getSymbols()
                }
                self.isLoadingMore = false
            }
        }
    }

    public func searchSymbols(with name: String) {
        // Cancel any existing search task
        searchTask?.cancel()
        
        // Create a new search task with debounce
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000) // 300ms debounce
            guard !Task.isCancelled else { return }
            
            isSearching = true
            DispatchQueue.main.async {
                if self.useCustomSymbols {
                    // Filter custom symbols by name
                    let filtered = self.customSymbols.filter { symbol in
                        symbol.lowercased().contains(name.lowercased())
                    }
                    self.symbols = filtered
                } else {
                    self.symbols = self.symbolLoader.getSymbols(named: name)
                }
                self.isLoading = false
            }
        }
    }

    public func reset() {
        if useCustomSymbols {
            // Reset to custom symbols
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
            loadSymbols()
        }
    }
}
