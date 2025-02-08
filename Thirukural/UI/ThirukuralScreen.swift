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
    
    @State private var expandedSection: String? = nil
    @State private var showSearch: Bool = false  // Controls presentation of search view
    @State private var selectedKuralNumber: Int? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                // Main content
                if let viewState = viewModel.kuralViewState {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("#\(viewState.kuralNumber)")
                                .font(.largeTitle)
                            
                            Text(viewState.verse)
                                .font(.body)
                            
                            if let imageName = getImageResourceName(kuralNumber: viewState.kuralNumber) {
                                Image(imageName)
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
                    }
                }
                
                // Navigation buttons at the bottom
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
                }
            }
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
                SearchScreen(viewModel: searchViewModel, selectedKuralNumber: $selectedKuralNumber)  // Pass the binding here
            }
        }
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
