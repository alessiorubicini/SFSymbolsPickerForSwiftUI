//
//  SymbolsPickerViewModel.swift
//
//
//  Created by Alessio Rubicini on 25/02/24.
//

import Foundation
import SwiftUI

public class SymbolsPickerViewModel: ObservableObject {
    
    let title: Text
    let searchbarLabel: Text
    let autoDismiss: Bool
    private let symbolLoader: SymbolLoader = SymbolLoader()
    private var searchTask: Task<Void, Never>?

    @Published var symbols: [String] = []
    @Published var isLoading: Bool = true
    @Published var isLoadingMore: Bool = false
    private var isSearching: Bool = false

    init(title: Text, searchbarLabel: Text, autoDismiss: Bool) {
        self.title = title
        self.searchbarLabel = searchbarLabel
        self.autoDismiss = autoDismiss

        NotificationCenter.default.addObserver(self, selector: #selector(updateSymbols), name: .symbolsLoaded, object: nil)

        self.loadSymbols()
    }

    @objc private func updateSymbols() {
        DispatchQueue.main.async {
            self.symbols = self.symbolLoader.getSymbols()
            self.isLoading = false
        }
    }

    public var hasMoreSymbols: Bool {
        return !isSearching && symbolLoader.hasMoreSymbols()
    }

    public func loadSymbols() {
        DispatchQueue.main.async {
            self.symbols = self.symbolLoader.getSymbols()
            self.isLoading = false
        }
    }

    public func loadMoreSymbols() {
        guard !isLoadingMore && hasMoreSymbols else { return }
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
                self.symbols = self.symbolLoader.getSymbols(named: name)
                self.isLoading = false
            }
        }
    }

    public func reset() {
        symbolLoader.resetPagination()
        symbols.removeAll()
        isLoading = true
        isSearching = false
        isLoadingMore = false
        searchTask?.cancel()
        loadSymbols()
    }
}
