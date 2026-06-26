//
//  SwiftUIView.swift
//
//
//  Created by Alessio Rubicini on 22/10/23.
//

import SwiftUI
import SFSafeSymbols

public struct SymbolsPicker<Content: View>: View {
    
    @Binding var selection: String
    @State var vm: SymbolsPickerViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.symbolsPickerGrid) var gridConfig
    @State private var searchText = ""
    let closeButtonView: Content

    /// Initialize the SymbolsPicker view
    /// - Parameters:
    ///   - selection: binding to the selected icon name.
    ///   - title: navigation title for the view.
    ///   - searchLabel: label for the search bar. Set to 'Search...' by default.
    ///   - autoDismiss: if true the view automatically dismisses itself when the symbols is selected.
    ///   - symbols: an array of SFSymbols to display. If empty, all symbols will be shown.
    ///   - closeButton: a custom view for the picker close button. Set to 'Image(systemName: "xmark.circle")' by default.
    public init(
        selection: Binding<String>,
        title: Text,
        searchLabel: Text,
        autoDismiss: Bool = false,
        symbols: [SFSymbol] = [],
        @ViewBuilder closeButton: () -> Content = { Image(systemName: "xmark.circle") }
    ) {
        self._selection = selection
        self._vm = State(initialValue: SymbolsPickerViewModel(
            title: title,
            searchbarLabel: searchLabel,
            autoDismiss: autoDismiss,
            symbols: symbols
        ))
        self.closeButtonView = closeButton()
    }

    public var body: some View {
        NavigationStack {
            VStack {
                Group {
                    if(vm.isLoading) {
                        ProgressView()
                            .scaleEffect(1.2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if vm.symbols.isEmpty && !searchText.isEmpty {
                        ContentUnavailableView {
                            Label {
                                Text("No Symbols Found", bundle: .module)
                            } icon: {
                                Image(systemName: "magnifyingglass")
                            }

                        } description: {
                            Text("Try searching for something else", bundle: .module)
                        }
                    } else {
                        ScrollView(.vertical) {
                            LazyVGrid(
                                columns: [
                                    GridItem(.adaptive(minimum: gridConfig.minimumSize, maximum: gridConfig.maximumSize), spacing: gridConfig.spacing)
                                ],
                                spacing: gridConfig.spacing
                            ) {
                                ForEach(vm.symbols, id: \.self) { icon in
                                    SymbolIcon(symbolName: icon, selection: $selection)
                                }
                                
                                if vm.hasMoreSymbols && searchText.isEmpty {
                                    if vm.isLoadingMore {
                                        ProgressView()
                                            .padding()
                                    } else {
                                        Color.clear
                                            .frame(height: 1)
                                            .onAppear {
                                                vm.loadMoreSymbols()
                                            }
                                    }
                                }
                            }
                            .padding(8)
                        }
                        .scrollIndicators(.hidden)
                        .scrollDisabled(false)
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 10)
                                .onChanged { _ in }
                        )
                        #if !os(visionOS)
                        .scrollDismissesKeyboard(.immediately)
                        #endif
                    }
                }
                .navigationTitle(vm.title)
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            closeButtonView
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: vm.searchbarLabel)
        }
        .onChange(of: selection) { oldValue, newValue in
            if vm.autoDismiss {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .onChange(of: searchText) { oldValue, newValue in
            if newValue.isEmpty {
                vm.reset()
            } else {
                vm.searchSymbols(with: newValue)
            }
        }
    }
}

extension SymbolsPicker {
    /// Initialize the SymbolsPicker view
    /// - Parameters:
    ///   - selection: binding to the selected icon name.
    ///   - titleKey: navigation title for the view.
    ///   - searchLabel: label for the search bar.
    ///   - autoDismiss: if true the view automatically dismisses itself when the symbols is selected.
    ///   - symbols: an array of SFSymbols to display. If empty, all symbols will be shown.
    ///   - closeButton: a custom view for the picker close button. Set to 'Image(systemName: "xmark.circle")' by default.

    public init(
        selection: Binding<String>,
        titleKey: LocalizedStringKey,
        searchLabel: LocalizedStringKey,
        bundle: Bundle? = nil,
        autoDismiss: Bool = false,
        symbols: [SFSymbol] = [],
        @ViewBuilder closeButton: () -> Content = { Image(systemName: "xmark.circle") }
    ) {
        self._selection = selection
        let resolvedBundle = bundle ?? .module
        self._vm = State(initialValue: SymbolsPickerViewModel(
            title: Text(titleKey, bundle: resolvedBundle),
            searchbarLabel: Text(searchLabel, bundle: resolvedBundle),
            autoDismiss: autoDismiss,
            symbols: symbols
        ))
        self.closeButtonView = closeButton()
    }

    /// Initialize the SymbolsPicker view
    /// - Parameters:
    ///   - selection: binding to the selected icon name.
    ///   - titleKey: navigation title for the view.
    ///   - autoDismiss: if true the view automatically dismisses itself when the symbols is selected.
    ///   - symbols: an array of SFSymbols to display. If empty, all symbols will be shown.
    ///   - closeButton: a custom view for the picker close button. Set to 'Image(systemName: "xmark.circle")' by default.

    public init(
        selection: Binding<String>,
        titleKey: LocalizedStringKey,
        bundle: Bundle? = nil,
        autoDismiss: Bool = false,
        symbols: [SFSymbol] = [],
        @ViewBuilder closeButton: () -> Content = { Image(systemName: "xmark.circle") }
    ) {
        self._selection = selection
        self._vm = State(initialValue: SymbolsPickerViewModel(
            title: Text(titleKey, bundle: bundle ?? .module),
            searchbarLabel: Text("Search...", bundle: .module),
            autoDismiss: autoDismiss,
            symbols: symbols
        ))
        self.closeButtonView = closeButton()
    }

    /// Initialize the SymbolsPicker view
    /// - Parameters:
    ///   - selection: binding to the selected icon name.
    ///   - title: navigation title for the view.
    ///   - searchLabel: label for the search bar. Set to 'Search...' by default.
    ///   - autoDismiss: if true the view automatically dismisses itself when the symbols is selected.
    ///   - symbols: an array of SFSymbols to display. If empty, all symbols will be shown.
    ///   - closeButton: a custom view for the picker close button. Set to 'Image(systemName: "xmark.circle")' by default.
    public init(
        selection: Binding<String>,
        title: String,
        searchLabel: String = "Search...",
        autoDismiss: Bool = false,
        symbols: [SFSymbol] = [],
        @ViewBuilder closeButton: () -> Content = { Image(systemName: "xmark.circle") }
    ) {
        self._selection = selection
        self._vm = State(initialValue: SymbolsPickerViewModel(
            title: Text(title),
            searchbarLabel: Text(searchLabel),
            autoDismiss: autoDismiss,
            symbols: symbols
        ))
        self.closeButtonView = closeButton()
    }
}

extension Binding where Value == String {
    init(sfSymbolBinding: Binding<SFSymbol>) {
        self.init(
            get: { sfSymbolBinding.wrappedValue.rawValue },
            set: { newValue in
                sfSymbolBinding.wrappedValue = SFSymbol(rawValue: newValue)
            }
        )
    }
    
    init(sfSymbolBinding: Binding<SFSymbol?>) {
        self.init(
            get: { sfSymbolBinding.wrappedValue?.rawValue ?? "" },
            set: { newValue in
                sfSymbolBinding.wrappedValue = SFSymbol(rawValue: newValue)
            }
        )
    }
}

extension SymbolsPicker {
    
    // MARK: - SFSymbol Bindings

    public init(
        selection: Binding<SFSymbol>,
        title: Text,
        searchLabel: Text,
        autoDismiss: Bool = false,
        symbols: [SFSymbol] = [],
        @ViewBuilder closeButton: () -> Content = { Image(systemName: "xmark.circle") }
    ) {
        self.init(selection: Binding(sfSymbolBinding: selection), title: title, searchLabel: searchLabel, autoDismiss: autoDismiss, symbols: symbols, closeButton: closeButton)
    }

    public init(
        selection: Binding<SFSymbol?>,
        title: Text,
        searchLabel: Text,
        autoDismiss: Bool = false,
        symbols: [SFSymbol] = [],
        @ViewBuilder closeButton: () -> Content = { Image(systemName: "xmark.circle") }
    ) {
        self.init(selection: Binding(sfSymbolBinding: selection), title: title, searchLabel: searchLabel, autoDismiss: autoDismiss, symbols: symbols, closeButton: closeButton)
    }

    public init(
        selection: Binding<SFSymbol>,
        titleKey: LocalizedStringKey,
        searchLabel: LocalizedStringKey,
        bundle: Bundle? = nil,
        autoDismiss: Bool = false,
        symbols: [SFSymbol] = [],
        @ViewBuilder closeButton: () -> Content = { Image(systemName: "xmark.circle") }
    ) {
        self.init(selection: Binding(sfSymbolBinding: selection), titleKey: titleKey, searchLabel: searchLabel, bundle: bundle, autoDismiss: autoDismiss, symbols: symbols, closeButton: closeButton)
    }

    public init(
        selection: Binding<SFSymbol?>,
        titleKey: LocalizedStringKey,
        searchLabel: LocalizedStringKey,
        bundle: Bundle? = nil,
        autoDismiss: Bool = false,
        symbols: [SFSymbol] = [],
        @ViewBuilder closeButton: () -> Content = { Image(systemName: "xmark.circle") }
    ) {
        self.init(selection: Binding(sfSymbolBinding: selection), titleKey: titleKey, searchLabel: searchLabel, bundle: bundle, autoDismiss: autoDismiss, symbols: symbols, closeButton: closeButton)
    }

    public init(
        selection: Binding<SFSymbol>,
        titleKey: LocalizedStringKey,
        bundle: Bundle? = nil,
        autoDismiss: Bool = false,
        symbols: [SFSymbol] = [],
        @ViewBuilder closeButton: () -> Content = { Image(systemName: "xmark.circle") }
    ) {
        self.init(selection: Binding(sfSymbolBinding: selection), titleKey: titleKey, bundle: bundle, autoDismiss: autoDismiss, symbols: symbols, closeButton: closeButton)
    }

    public init(
        selection: Binding<SFSymbol?>,
        titleKey: LocalizedStringKey,
        bundle: Bundle? = nil,
        autoDismiss: Bool = false,
        symbols: [SFSymbol] = [],
        @ViewBuilder closeButton: () -> Content = { Image(systemName: "xmark.circle") }
    ) {
        self.init(selection: Binding(sfSymbolBinding: selection), titleKey: titleKey, bundle: bundle, autoDismiss: autoDismiss, symbols: symbols, closeButton: closeButton)
    }

    public init(
        selection: Binding<SFSymbol>,
        title: String,
        searchLabel: String = "Search...",
        autoDismiss: Bool = false,
        symbols: [SFSymbol] = [],
        @ViewBuilder closeButton: () -> Content = { Image(systemName: "xmark.circle") }
    ) {
        self.init(selection: Binding(sfSymbolBinding: selection), title: title, searchLabel: searchLabel, autoDismiss: autoDismiss, symbols: symbols, closeButton: closeButton)
    }

    public init(
        selection: Binding<SFSymbol?>,
        title: String,
        searchLabel: String = "Search...",
        autoDismiss: Bool = false,
        symbols: [SFSymbol] = [],
        @ViewBuilder closeButton: () -> Content = { Image(systemName: "xmark.circle") }
    ) {
        self.init(selection: Binding(sfSymbolBinding: selection), title: title, searchLabel: searchLabel, autoDismiss: autoDismiss, symbols: symbols, closeButton: closeButton)
    }
}

#Preview {
    SymbolsPicker(selection: .constant("beats.powerbeatspro"), title: "Pick a symbol", autoDismiss: true)
}
