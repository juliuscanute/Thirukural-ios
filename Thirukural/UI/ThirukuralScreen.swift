//
//  ThirukuralScreen.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//

import SwiftUI

struct ThirukuralScreen: View {
    let innerPadding: EdgeInsets
    @ObservedObject var viewModel: ThirukuralViewModel
    @ObservedObject var searchViewModel: SearchViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State private var expandedSection: String? = nil
    @State private var showSearch: Bool = false  // Controls presentation of search view
    @State private var selectedKuralNumber: Int? = nil
    
    var body: some View {
        Group {
            if isRegularWidth {
                iPadLayout
            } else {
                iPhoneLayout
            }
        }
    }
}

// MARK: - Layouts

private extension ThirukuralScreen {
    var isRegularWidth: Bool {
        horizontalSizeClass == .regular
    }
    
    var iPhoneLayout: some View {
        NavigationView {
            contentStack()
                .navigationBarTitle("Thirukural", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showSearch.toggle()
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(TKuralColorScheme.light.primary)
                        }
                    }
                }
                .sheet(isPresented: $showSearch, onDismiss: {
                    if let kuralNumber = selectedKuralNumber {
                        Task {
                            await viewModel.loadKural(kuralNo: kuralNumber)
                        }
                    }
                }) {
                    SearchScreen(viewModel: searchViewModel, selectedKuralNumber: $selectedKuralNumber)
                }
        }
    }
    
    var iPadLayout: some View {
        NavigationSplitView {
            SearchSidebar(
                viewModel: searchViewModel,
                selectedKuralNumber: $selectedKuralNumber,
                onKuralSelected: handleSidebarSelection
            )
            .frame(minWidth: 320, idealWidth: 360)
        } detail: {
            contentStack(maxWidth: 700)
                .navigationBarTitle("Thirukural", displayMode: .inline)
        }
    }
    
    @ViewBuilder
    func contentStack(maxWidth: CGFloat? = nil) -> some View {
        VStack(spacing: 16) {
            kuralContent(maxWidth: maxWidth)
            
            navigationButtons(maxWidth: maxWidth)
        }
    }
    
    @ViewBuilder
    func kuralContent(maxWidth: CGFloat? = nil) -> some View {
        if let viewState = viewModel.kuralViewState {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("#\(viewState.kuralNumber)")
                        .font(.largeTitle)
                    
                    Text(viewState.verse)
                        .font(.body)
                    
                    if let kuralImage = loadKuralImage(kuralNumber: viewState.kuralNumber) {
                        kuralImage
                            .resizable()
                            .scaledToFit()
                    }
                    
                    CollapsibleSection(
                        title: "Word Meanings",
                        isExpanded: expandedSection == "Word Meanings",
                        onExpand: {
                            expandedSection = (expandedSection == "Word Meanings") ? nil : "Word Meanings"
                        }
                    ) {
                        WordMeaningItem(meanings: viewState.wordMeanings)
                    }
                    
                    CollapsibleSection(
                        title: "Detailed Explanation",
                        isExpanded: expandedSection == "Explanation",
                        onExpand: {
                            expandedSection = (expandedSection == "Explanation") ? nil : "Explanation"
                        }
                    ) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(viewState.explanation)
                                .font(.body)
                            
                            Text(viewState.combinedExplanation)
                                .font(.body)
                        }
                    }
                    
                    CollapsibleSection(
                        title: "Story",
                        isExpanded: expandedSection == "Story",
                        onExpand: {
                            expandedSection = (expandedSection == "Story") ? nil : "Story"
                        }
                    ) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(viewState.story.title)
                                .font(.headline)
                            
                            Text(viewState.story.content)
                                .font(.body)
                            
                            Text("Moral")
                                .font(.headline)
                            
                            Text(viewState.story.moral)
                                .font(.body)
                        }
                    }
                    
                    CollapsibleSection(
                        title: "Themes",
                        isExpanded: expandedSection == "Themes",
                        onExpand: {
                            expandedSection = (expandedSection == "Themes") ? nil : "Themes"
                        }
                    ) {
                        Text(viewState.theme.joined(separator: ", "))
                            .font(.body)
                    }
                }
                .padding(innerPadding)
                .frame(maxWidth: maxWidth ?? .infinity, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    @ViewBuilder
    func navigationButtons(maxWidth: CGFloat? = nil) -> some View {
        if let navigationState = viewModel.navigationViewState {
            HStack {
                Button(action: {
                    Task {
                        await viewModel.loadPreviousKural(viewModel.kuralViewState?.kuralNumber)
                    }
                }) {
                    Text("Previous")
                }
                .disabled(!navigationState.previous.enabled)
                .buttonStyle(MaterialButtonStyle(colorScheme: TKuralColorScheme.light))
                
                Button(action: {
                    Task {
                        await viewModel.loadNextKural(viewModel.kuralViewState?.kuralNumber)
                    }
                }) {
                    Text("Next")
                }
                .disabled(!navigationState.next.enabled)
                .buttonStyle(MaterialButtonStyle(colorScheme: TKuralColorScheme.light))
            }
            .padding()
            .frame(maxWidth: maxWidth ?? .infinity)
            .frame(maxWidth: .infinity)
        }
    }
    
    func handleSidebarSelection(_ kuralNumber: Int) {
        selectedKuralNumber = kuralNumber
        Task {
            await viewModel.loadKural(kuralNo: kuralNumber)
        }
    }
}

// MARK: - Search Sidebar for iPad

private struct SearchSidebar: View {
    @ObservedObject var viewModel: SearchViewModel
    @Binding var selectedKuralNumber: Int?
    let onKuralSelected: (Int) -> Void
    
    @State private var query: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Search by Kural, Word, or Theme", text: $query)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: query) { _, newValue in
                    viewModel.searchViewState.onQuery(newValue)
                }
                .padding(.top, 24)
            
            if viewModel.searchViewState.suggestions.isEmpty && !query.isEmpty {
                Text("No results found")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            } else {
                List(viewModel.searchViewState.suggestions) { suggestion in
                    SearchSuggestionCard(result: suggestion) { kuralNumber in
                        selectedKuralNumber = kuralNumber
                        onKuralSelected(kuralNumber)
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                }
                .listStyle(PlainListStyle())
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationTitle("Search")
    }
}



//struct PreviewThirukuralScreen: View {
//    @StateObject private var viewModel: ThirukuralViewModel = {
//        // Initialize the view model. Use a closure to set a dummy view state.
//        let vm = ThirukuralViewModel(
//            kuralRepository: ThirukuralRepository(dao: try! ThirukuralDAO(databasePath: "")),
//            kuralViewStateMapper: KuralViewStateMapper()
//        )
//        vm.kuralViewState = ThirukuralViewState(
//            kuralNumber: 1,
//            verse: "அகர முதல எழுத்தெல்லாம் ஆதி\nபகவன் முதற்றே உலகு.",
//            wordMeanings: [
//                WordMeaningViewState(
//                    term: "அகர",
//                    transliteration: "Akar",
//                    index: 1,
//                    meaning: "'Akar' is the first letter in the Tamil alphabet, which is 'அ'."
//                ),
//                WordMeaningViewState(
//                    term: "முதல",
//                    transliteration: "Mudhal",
//                    index: 2,
//                    meaning: "'Mudhal' translates to 'first' or 'beginning'."
//                ),
//                WordMeaningViewState(
//                    term: "உலகு",
//                    transliteration: "Ulagu",
//                    index: 7,
//                    meaning: "'Ulagu' denotes 'the world'."
//                )
//            ],
//            combinedExplanation: "Just as 'Akar' is the first of all letters...",
//            explanation: "The Kural begins with an analogy...",
//            story: StoryViewState(
//                title: "The Origin of the Alphabet",
//                content: "Once upon a time, in a realm unknown...",
//                moral: "The story underlines that everything originated..."
//            ),
//            theme: ["Divinity", "Creation"]
//        )
//        return vm
//    }()
//
//    var body: some View {
//        ThirukuralScreen(
//            innerPadding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
//            viewModel: viewModel
//        )
//    }
//}
//
//struct PreviewThirukuralScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        PreviewThirukuralScreen()
//    }
//}
