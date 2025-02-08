//
//  ThirukuralModel.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//
import Foundation

struct NavigationViewState {
    let next: ButtonViewState
    let previous: ButtonViewState
}

struct ButtonViewState {
    let enabled: Bool
    let onClick: () async -> Void
}

struct ThirukuralViewState {
    let kuralNumber: Int
    let verse: String
    let wordMeanings: [WordMeaningViewState]
    let combinedExplanation: String
    let explanation: String
    let story: StoryViewState
    let theme: [String]
}

struct WordMeaningViewState {
    let term: String
    let transliteration: String
    let index: Int
    let meaning: String
}

struct StoryViewState {
    let title: String
    let content: String
    let moral: String
}
