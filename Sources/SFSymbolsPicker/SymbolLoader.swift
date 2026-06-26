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
@MainActor
public class SymbolLoader {
    private let symbolsPerPage = 100
    private var currentPage = 0
    private final var allSymbols: [String] = []
    private var loadedSymbols: [String] = []

    public init() {}

    public func getSymbols() async -> [String] {
        if allSymbols.isEmpty {
            await loadAllSymbols()
        }
        
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

    public func getSymbols(named name: String) async -> [String] {
        if name.isEmpty { return [] }
        if allSymbols.isEmpty {
            await loadAllSymbols()
        }
        
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

    private func loadAllSymbols() async {
        guard allSymbols.isEmpty else { return }
        
        let loaded: [String]? = await Task.detached {
            var retryCount = 0
            while retryCount < 3 {
                if let bundle = Bundle(identifier: "com.apple.CoreGlyphs"),
                   let resourcePath = bundle.path(forResource: "name_availability", ofType: "plist"),
                   let plist = NSDictionary(contentsOfFile: resourcePath),
                   let plistSymbols = plist["symbols"] as? [String: String] {
                    return Array(plistSymbols.keys).sorted(by: { $1 > $0 })
                }
                
                print("Failed: Bundle 'com.apple.CoreGlyphs' not found. Retrying...")
                retryCount += 1
                try? await Task.sleep(nanoseconds: 100_000_000)
            }
            return nil
        }.value
        
        if let loaded {
            print("Successfully loaded \(loaded.count) SF Symbols.")
            self.allSymbols = loaded
        }
    }
}
