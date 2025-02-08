//
//  SearchViewModel.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    private let repository: ThirukuralRepository
    private let searchViewStateMapper: SearchViewStateMapper
    
    /// The published UI state.
    @Published var searchViewState: SearchResultUiState
    
    /// Dependency injection via the initializer.
    init(repository: ThirukuralRepository, searchViewStateMapper: SearchViewStateMapper) {
        self.repository = repository
        self.searchViewStateMapper = searchViewStateMapper
        self.searchViewState = SearchResultUiState(onQuery: { _ in }, suggestions: [])
        self.searchViewState = searchViewStateMapper.mapToInitialState(viewModel: self)
    }
    
    /// Called when a new search query is entered.
    func searchByAll(query: String) {
        Task {
            // Call the repository asynchronously.
            let results = try await repository.searchByAll(query: query)
            // Update the UI state on the main actor.
            await MainActor.run {
                self.searchViewState = self.searchViewStateMapper.mapToUiState(viewModel: self, suggestions: results)
            }
        }
    }
}
