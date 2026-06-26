import XCTest
import SwiftUI
import SFSafeSymbols
@testable import SFSymbolsPicker

final class SFSymbolsPickerTests: XCTestCase {
    
    @MainActor
    func testSymbolLoaderGetSymbols() async {
        guard Bundle(identifier: "com.apple.CoreGlyphs") != nil else {
            print("Skipping testSymbolLoaderGetSymbols: com.apple.CoreGlyphs bundle not available in this test environment.")
            return
        }

        let loader = SymbolLoader()
        let symbols = await loader.getSymbols()
        
        XCTAssertFalse(symbols.isEmpty, "Symbols should not be empty after loading")
        XCTAssertTrue(loader.hasMoreSymbols(), "There should be more symbols to load")
    }
    
    @MainActor
    func testSymbolsPickerVMCustomSymbols() async {
        let symbols: [SFSymbol] = [.starFill, .heartFill]
        let vm = SymbolsPickerViewModel(title: Text("Test"), searchbarLabel: Text("Search"), autoDismiss: false, symbols: symbols)
        
        XCTAssertEqual(vm.symbols.count, 2)
        XCTAssertEqual(vm.symbols[0], SFSymbol.starFill.rawValue)
        XCTAssertEqual(vm.isLoading, false)
        
        // Test search
        vm.searchSymbols(with: "heart")
        
        // Wait for search debounce
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(vm.symbols.count, 1)
        XCTAssertEqual(vm.symbols.first, SFSymbol.heartFill.rawValue)
    }
}
