//
//  SearchViewStateMapper.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//

import SwiftUI
import UIKit  // Needed for UIFont


// MARK: - View-State Models

/// Represents a single suggestion for display.
struct SuggestionUiState: Identifiable {
    let id = UUID()
    let kuralNumber: Int
    let kuralText: AttributedString
}

/// Represents the entire search result UI state.
struct SearchResultUiState {
    /// Called whenever the query text changes.
    let onQuery: (String) -> Void
    /// The list of suggestions.
    let suggestions: [SuggestionUiState]
}

// MARK: - Mapper

class SearchViewStateMapper {
    
    /// Maps the initial state with no suggestions.
    func mapToInitialState(viewModel: SearchViewModel) -> SearchResultUiState {
        return SearchResultUiState(
            onQuery: { query in
                viewModel.searchByAll(query: query)
            },
            suggestions: []
        )
    }
    
    /// Maps a list of `KuralSuggestion` models to the UI state.
    func mapToUiState(
        viewModel: SearchViewModel,
        suggestions: [KuralSuggestion]
    ) -> SearchResultUiState {
        
        let mappedSuggestions = suggestions.map { suggestion -> SuggestionUiState in
            // Build an AttributedString similar to the Kotlin AnnotatedString.
            var result = AttributedString("")
            
            // Bold style for the kural number.
            var boldAttributes = AttributeContainer()
            boldAttributes.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            let boldText = AttributedString("\(suggestion.kuralNumber). ", attributes: boldAttributes)
            result.append(boldText)
            
            // Append the main kural text using the default style.
            let normalText = AttributedString(suggestion.kural)
            result.append(normalText)
            
            // Append context (if available) using normal (regular) weight.
            if let context = suggestion.context {
                var normalAttributes = AttributeContainer()
                normalAttributes.font = UIFont.systemFont(ofSize: 17, weight: .regular)
                let contextText = AttributedString(" - \(context)", attributes: normalAttributes)
                result.append(contextText)
            }
            
            return SuggestionUiState(
                kuralNumber: suggestion.kuralNumber,
                kuralText: result
            )
        }
        
        return SearchResultUiState(
            onQuery: { query in
                viewModel.searchByAll(query: query)
            },
            suggestions: mappedSuggestions
        )
    }
}
