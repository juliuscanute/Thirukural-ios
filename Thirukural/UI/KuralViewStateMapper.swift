//
//  KuralViewStateMapper.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//

import Foundation


class KuralViewStateMapper {
    
    /// Converts a ThirukuralWithDetails model into a view state.
    func mapToViewState(kuralWithDetails: ThirukuralWithDetails) -> ThirukuralViewState {
        return ThirukuralViewState(
            kuralNumber: kuralWithDetails.thirukural.kuralNumber,
            verse: kuralWithDetails.thirukural.verse,
            wordMeanings: kuralWithDetails.wordMeanings.map { meaning in
                WordMeaningViewState(
                    term: meaning.term,
                    transliteration: meaning.transliteration,
                    index: meaning.position,
                    meaning: meaning.meaning
                )
            },
            combinedExplanation: kuralWithDetails.thirukural.combinedExplanation,
            explanation: kuralWithDetails.thirukural.explanation,
            story: StoryViewState(
                title: kuralWithDetails.thirukural.storyTitle,
                content: kuralWithDetails.thirukural.storyContent,
                moral: kuralWithDetails.thirukural.storyMoral
            ),
            theme: kuralWithDetails.themes.map { $0.theme }
        )
    }
    
    /// Creates a NavigationViewState based on the current kural number and total count.
    func mapToNavigationState(viewModel: ThirukuralViewModel, kuralNumber: Int, totalCount: Int) async -> NavigationViewState {
        return NavigationViewState(
            next: ButtonViewState(
                enabled: kuralNumber < totalCount,
                onClick: { await viewModel.loadNextKural(kuralNumber + 1) }
            ),
            previous: ButtonViewState(
                enabled: kuralNumber > 1,
                onClick: { await viewModel.loadPreviousKural(kuralNumber - 1) }
            )
        )
    }
}
