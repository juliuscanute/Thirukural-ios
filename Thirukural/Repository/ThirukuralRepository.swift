//
//  ThirukuralRepository.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//
import Foundation

class ThirukuralRepository {
    private let dao: ThirukuralDAO
    private let thirukuralDataStore: ThirukuralDataStore

    
    init(thirukuralDao: ThirukuralDAO, thirukuralDataStore: ThirukuralDataStore){
        self.dao = thirukuralDao
        self.thirukuralDataStore = thirukuralDataStore
    }
    
    var kuralNumber: Int {
        return thirukuralDataStore.getKuralNumber()
    }
    
    func saveKuralNumber(_ kuralNumber: Int) {
        thirukuralDataStore.saveKuralNumber(kuralNumber)
    }
    
    // Returns the total number of Thirukurals.
    func getThirukuralCount() async -> Int {
        do {
            return try dao.getThirukuralCount()
        } catch {
            return 0 // Return zero if there's an error
        }
    }
    
    // Returns details for a given kural number.
    func getThirukuralWithDetails(kuralNumber: Int) async -> ThirukuralWithDetails? {
        do {
            return try dao.getThirukuralWithDetails(kuralNumber: kuralNumber)
        } catch {
            return nil
        }
    }
    
    // Searches by query across several fields.
    func searchByAll(query: String) async throws -> [KuralSuggestion] {
        guard !query.isEmpty else { return [] }
        var suggestions = [KuralSuggestion]()
        
        if let kuralNumberSuggestions = try? searchByKuralNumber(query: query) {
            suggestions.append(contentsOf: kuralNumberSuggestions)
        }
        if let wordMeaningsSuggestions = try? searchByWordMeanings(query: query) {
            suggestions.append(contentsOf: wordMeaningsSuggestions)
        }
        if let themesSuggestions = try? searchByThemes(query: query) {
            suggestions.append(contentsOf: themesSuggestions)
        }
        if let transliterationSuggestions = try? searchByTransliteration(query: query) {
            suggestions.append(contentsOf: transliterationSuggestions)
        }
        if let meaningSuggestions = try? searchByMeaning(query: query) {
            suggestions.append(contentsOf: meaningSuggestions)
        }
        if let verseSuggestions = try? searchByVerse(query: query) {
            suggestions.append(contentsOf: verseSuggestions)
        }
        if let combinedExplanationSuggestions = try? searchByCombinedExplanation(query: query) {
            suggestions.append(contentsOf: combinedExplanationSuggestions)
        }
        if let explanationSuggestions = try? searchByExplanation(query: query) {
            suggestions.append(contentsOf: explanationSuggestions)
        }
        if let storyTitleSuggestions = try? searchByStoryTitle(query: query) {
            suggestions.append(contentsOf: storyTitleSuggestions)
        }
        if let storyContentSuggestions = try? searchByStoryContent(query: query) {
            suggestions.append(contentsOf: storyContentSuggestions)
        }
        if let storyMoralSuggestions = try? searchByStoryMoral(query: query) {
            suggestions.append(contentsOf: storyMoralSuggestions)
        }
        
        if suggestions.isEmpty {
            return []
        } else {
            // Remove duplicate suggestions (KuralSuggestion conforms to Hashable)
            return Array(Set(suggestions))
        }
    }
    
    // MARK: - Private Search Functions
    
    private func searchByKuralNumber(query: String) throws -> [KuralSuggestion] {
        guard let kuralNumber = Int(query), kuralNumber > 0 else {
            throw DataError.invalidInput(reason: "Invalid kural number")
        }
        
        do {
            let detail = try dao.getThirukuralWithDetails(kuralNumber: kuralNumber)
            return [
                KuralSuggestion(
                    kuralNumber: kuralNumber,
                    kural: detail.thirukural.verse,
                    context: nil
                )
            ]
        } catch {
            throw DataError.invalidInput(reason: "Invalid query")
        }
    }
    
    private func searchByWordMeanings(query: String) throws -> [KuralSuggestion] {
        let wordMeanings = try dao.getWordMeaningsByTerm(query)
        guard !wordMeanings.isEmpty else { return [] }
        
        let details = try wordMeanings.compactMap { wm in
            try dao.getThirukuralWithDetailsFromId(wm.thirukuralId)
        }
        
        return details.map { detail in
            let context = detail.wordMeanings.map { $0.term }.joined(separator: ", ")
            return KuralSuggestion(kuralNumber: detail.thirukural.kuralNumber,
                                   kural: detail.thirukural.verse,
                                   context: context)
        }
    }
    
    private func searchByThemes(query: String) throws -> [KuralSuggestion] {
        let themes = try dao.getThemesByTheme(query)
        guard !themes.isEmpty else { return [] }
        
        let details = try themes.compactMap { theme in
            try dao.getThirukuralWithDetailsFromId(theme.thirukuralId)
        }
        
        return details.map { detail in
            let context = detail.themes.map { $0.theme }.joined(separator: ", ")
            return KuralSuggestion(kuralNumber: detail.thirukural.kuralNumber,
                                   kural: detail.thirukural.verse,
                                   context: context)
        }
    }
    
    private func searchByTransliteration(query: String) throws -> [KuralSuggestion] {
        let wordMeanings = try dao.getWordMeaningByTransliteration(query)
        guard !wordMeanings.isEmpty else { return [] }
        
        let details = try wordMeanings.compactMap { wm in
            try dao.getThirukuralWithDetailsFromId(wm.thirukuralId)
        }
        
        return details.map { detail in
            let context = detail.wordMeanings.map { $0.transliteration }.joined(separator: ", ")
            return KuralSuggestion(kuralNumber: detail.thirukural.kuralNumber,
                                   kural: detail.thirukural.verse,
                                   context: context)
        }
    }
    
    private func searchByMeaning(query: String) throws -> [KuralSuggestion] {
        let wordMeanings = try dao.getWordMeaningByMeaning(query)
        guard !wordMeanings.isEmpty else { return [] }
        
        let details = try wordMeanings.compactMap { wm in
            try dao.getThirukuralWithDetailsFromId(wm.thirukuralId)
        }
        
        return details.map { detail in
            let context = detail.wordMeanings.map { $0.meaning }.joined(separator: ", ")
            return KuralSuggestion(kuralNumber: detail.thirukural.kuralNumber,
                                   kural: detail.thirukural.verse,
                                   context: context)
        }
    }
    
    private func searchByVerse(query: String) throws -> [KuralSuggestion] {
        let thirukurals = try dao.getThirukuralByVerse(query)
        return thirukurals.map {
            KuralSuggestion(kuralNumber: $0.kuralNumber,
                            kural: $0.verse,
                            context: nil)
        }
    }
    
    private func searchByCombinedExplanation(query: String) throws -> [KuralSuggestion] {
        let thirukurals = try dao.getThirukuralByCombinedExplanation(query)
        return thirukurals.map {
            KuralSuggestion(kuralNumber: $0.kuralNumber,
                            kural: $0.verse,
                            context: $0.combinedExplanation)
        }
    }
    
    private func searchByExplanation(query: String) throws -> [KuralSuggestion] {
        let thirukurals = try dao.getThirukuralByExplanation(query)
        return thirukurals.map {
            KuralSuggestion(kuralNumber: $0.kuralNumber,
                            kural: $0.verse,
                            context: $0.explanation)
        }
    }
    
    private func searchByStoryTitle(query: String) throws -> [KuralSuggestion] {
        let thirukurals = try dao.getThirukuralByStoryTitle(query)
        return thirukurals.map {
            KuralSuggestion(kuralNumber: $0.kuralNumber,
                            kural: $0.verse,
                            context: $0.storyTitle)
        }
    }
    
    private func searchByStoryContent(query: String) throws -> [KuralSuggestion] {
        let thirukurals = try dao.getThirukuralByStoryContent(query)
        return thirukurals.map {
            KuralSuggestion(kuralNumber: $0.kuralNumber,
                            kural: $0.verse,
                            context: $0.storyContent)
        }
    }
    
    private func searchByStoryMoral(query: String) throws -> [KuralSuggestion] {
        let thirukurals = try dao.getThirukuralByStoryMoral(query)
        return thirukurals.map {
            KuralSuggestion(kuralNumber: $0.kuralNumber,
                            kural: $0.verse,
                            context: $0.storyMoral)
        }
    }
}
