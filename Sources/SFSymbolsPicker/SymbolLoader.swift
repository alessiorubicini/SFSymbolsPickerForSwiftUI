//
//  SymbolLoader.swift
//
//
//  Created by Alessio Rubicini on 31/10/23.
//

import Foundation

// This class is responsible for loading symbols from system
public class SymbolLoader {

    private let symbolsPerPage = 100
    private var currentPage = 0
    private final var allSymbols: [String] = []
    
    public init() {
        self.allSymbols = getAllSymbols()
    }

    // Retrieves symbols for the current page
    public func getSymbols() -> [String] {
        currentPage += 1

        // Calculate start and end index for the requested page
        let startIndex = (currentPage - 1) * symbolsPerPage
        let endIndex = min(startIndex + symbolsPerPage, allSymbols.count)

        // Extract symbols for the page
        return Array(allSymbols[startIndex..<endIndex])
    }
    
    // Retrieves symbols that start with the specified name
    public func getSymbols(named name: String) -> [String] {
        return allSymbols.filter({$0.lowercased().starts(with: name.lowercased())})
    }
    
    // Checks if there are more symbols available
    public func hasMoreSymbols() -> Bool {
        return currentPage * symbolsPerPage < allSymbols.count
    }
    
    // Resets the pagination to the initial state
    public func resetPagination() {
        currentPage = 0
    }
    
    // Loads all symbols from the plist file
    private func getAllSymbols() -> [String] {
        var allSymbols = [String]()
        if let bundle = Bundle(identifier: "com.apple.CoreGlyphs"),
            let resourcePath = bundle.path(forResource: "name_availability", ofType: "plist"),
            let plist = NSDictionary(contentsOfFile: resourcePath),
            let plistSymbols = plist["symbols"] as? [String: String]
        {
            // Get all symbol names
            allSymbols = Array(plistSymbols.keys)
        }
        return allSymbols
    }

}

