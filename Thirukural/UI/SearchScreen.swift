//
//  SearchScreen.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//

import SwiftUI

struct SearchScreen: View {
    @ObservedObject var viewModel: SearchViewModel
    @Environment(\.dismiss) private var dismiss  // For dismissing the sheet or view
    @State private var query: String = ""
    @Binding var selectedKuralNumber: Int?
    
    
    var body: some View {
        NavigationView {
            VStack {
                // Search field
                TextField("Search by Kural, Word, or Theme", text: $query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .frame(height: 48)  // Set the height of the text field
                // Call the onQuery closure whenever the text changes.
                    .onChange(of: query) { oldValue, newValue in
                        viewModel.searchViewState.onQuery(newValue)
                    }
                
                // If no suggestions and query is not empty, show "No results found".
                if viewModel.searchViewState.suggestions.isEmpty && !query.isEmpty {
                    Text("No results found")
                        .padding(.top, 16)
                } else {
                    // List of suggestions
                    List(viewModel.searchViewState.suggestions) { suggestion in
                        SearchSuggestionCard(result: suggestion) { kuralNumber in
                            // When a suggestion is tapped,
                            // do something with the kuralNumber.
                            // For example, print and then dismiss the view.
                            selectedKuralNumber = kuralNumber
                            print("Selected Kural: \(kuralNumber)")
                            dismiss()
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    }
                    .listStyle(PlainListStyle())
                }
                
                Spacer()
            }
            .navigationTitle("Thirukural Search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Search Suggestion Card

struct SearchSuggestionCard: View {
    let result: SuggestionUiState
    let onClick: (Int) -> Void
    
    var body: some View {
        Button(action: {
            onClick(result.kuralNumber)
        }) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Kural \(result.kuralNumber)")
                    .font(.headline)
                    .fontWeight(.bold)
                Text(result.kuralText)
                    .font(.body)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)  // Make the card occupy the available width
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
        }
        // Use PlainButtonStyle so the button doesn't show extra styling.
        .buttonStyle(PlainButtonStyle())
    }
}
