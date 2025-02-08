//
//  Thirukural.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//

import Foundation

/// Represents a row in the "thirukural" table.
struct ThirukuralData: Identifiable {
    var id: Int64?  // Primary key
    var kuralNumber: Int
    var verse: String
    var combinedExplanation: String
    var explanation: String
    var storyTitle: String
    var storyContent: String
    var storyMoral: String
}

/// Represents a row in the "word_meanings" table.
struct WordMeaningData: Identifiable {
    var id: Int64?  // Primary key
    var thirukuralId: Int64  // Foreign key to Thirukural.id
    var position: Int
    var term: String
    var transliteration: String
    var meaning: String
}

/// Represents a row in the "themes" table.
struct ThemeData: Identifiable {
    var id: Int64?  // Primary key
    var thirukuralId: Int64  // Foreign key to Thirukural.id
    var theme: String
}

/// Composite structure representing a Thirukural along with its Word Meanings and Themes.
struct ThirukuralWithDetails {
    var thirukural: ThirukuralData
    var wordMeanings: [WordMeaningData]
    var themes: [ThemeData]
}

struct KuralSuggestion: Hashable {
    let kuralNumber: Int
    let kural: String
    let context: String?
}

