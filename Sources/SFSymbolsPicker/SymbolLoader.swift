//
//  SymbolLoader.swift
//
//
//  Created by Alessio Rubicini on 31/10/23.
//

import Foundation

private extension String {
    func fuzzyMatch(_ pattern: String) -> Bool {
        let pattern = pattern.lowercased()
        let string = self.lowercased()
        
        if pattern.isEmpty { return true }
        if string.isEmpty { return false }
        
        var patternIndex = pattern.startIndex
        var stringIndex = string.startIndex
        
        while patternIndex < pattern.endIndex && stringIndex < string.endIndex {
            if pattern[patternIndex] == string[stringIndex] {
                patternIndex = pattern.index(after: patternIndex)
            }
            stringIndex = string.index(after: stringIndex)
        }
        
        return patternIndex == pattern.endIndex
    }
}

// This class is responsible for loading symbols from system
public class SymbolLoader {
    private let symbolsPerPage = 100
    private var currentPage = 0
    private final var allSymbols: [String] = []
    private var retryCount = 0  // Prevent infinite retries
    private var loadedSymbols: [String] = []

    public init() {
        // Load symbols asynchronously
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.loadAllSymbols()
        }
    }

    public func getSymbols() -> [String] {
        if currentPage == 0 {
            currentPage = 1
            let endIndex = min(symbolsPerPage, allSymbols.count)
            loadedSymbols = Array(allSymbols[0..<endIndex])
        }
        return loadedSymbols
    }

    public func loadNextPage() -> [String] {
        guard hasMoreSymbols() else { return [] }
        currentPage += 1
        let startIndex = (currentPage - 1) * symbolsPerPage
        let endIndex = min(startIndex + symbolsPerPage, allSymbols.count)
        let newSymbols = Array(allSymbols[startIndex..<endIndex])
        loadedSymbols.append(contentsOf: newSymbols)
        return newSymbols
    }

    public func getSymbols(named name: String) -> [String] {
        if name.isEmpty { return [] }
        
        // First try exact matches
        let exactMatches = allSymbols.filter { $0.lowercased().starts(with: name.lowercased()) }
        if !exactMatches.isEmpty {
            return exactMatches
        }
        
        // Then try fuzzy matches
        return allSymbols.filter { $0.fuzzyMatch(name) }
    }

    public func hasMoreSymbols() -> Bool {
        let nextPageStart = currentPage * symbolsPerPage
        return nextPageStart < allSymbols.count
    }

    public func resetPagination() {
        currentPage = 0
        loadedSymbols.removeAll()
    }

    private func loadAllSymbols() {
        guard let bundle = Bundle(identifier: "com.apple.CoreGlyphs") else {
            print("Failed: Bundle 'com.apple.CoreGlyphs' not found. Retrying...")
            if retryCount < 3 {  // Prevent infinite retries
                retryCount += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.loadAllSymbols() // Retry loading
                }
            }
            return
        }

        guard let resourcePath = bundle.path(forResource: "name_availability", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: resourcePath),
              let plistSymbols = plist["symbols"] as? [String: String] else {
            return
        }

        print("Successfully loaded \(plistSymbols.count) SF Symbols.")
        allSymbols = Array(plistSymbols.keys).sorted(by: { $1 > $0 })
        loadedSymbols = Array(allSymbols.prefix(symbolsPerPage))

        // Notify ViewModel to update UI on the main queue
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .symbolsLoaded, object: nil)
        }
    }
}

extension Notification.Name {
    static let symbolsLoaded = Notification.Name("symbolsLoaded")
}
