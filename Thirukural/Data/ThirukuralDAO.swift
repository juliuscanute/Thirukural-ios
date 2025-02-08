//
//  ThirukuralDAO.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//

import SQLite


enum DataError: Error {
    case notFound
    case invalidInput(reason: String)
}

class ThirukuralDAO {
    private let db: Connection
    
    // MARK: - Table Definitions
    private let thirukuralTable = Table("thirukural")
    private let wordMeaningsTable = Table("word_meanings")
    private let themesTable = Table("themes")
    
    // MARK: - Column Expressions for Thirukural
    private let idExp = Expression<Int64?>("id")
    private let kuralNumberExp = Expression<Int>("kural_number")
    private let verseExp = Expression<String>("verse")
    private let combinedExplanationExp = Expression<String>("combined_explanation")
    private let explanationExp = Expression<String>("explanation")
    private let storyTitleExp = Expression<String>("story_title")
    private let storyContentExp = Expression<String>("story_content")
    private let storyMoralExp = Expression<String>("story_moral")
    
    // MARK: - Column Expressions for Word Meanings
    private let wmIdExp = Expression<Int64?>("id")
    private let wmThirukuralIdExp = Expression<Int64>("thirukural_id")
    private let wmPositionExp = Expression<Int>("position")
    private let termExp = Expression<String>("term")
    private let transliterationExp = Expression<String>("transliteration")
    private let meaningExp = Expression<String>("meaning")
    
    // MARK: - Column Expressions for Themes
    private let themeIdExp = Expression<Int64?>("id")
    private let themeThirukuralIdExp = Expression<Int64>("thirukural_id")
    private let themeExp = Expression<String>("theme")
    
    // MARK: - Initializer
    init(databasePath: String) throws {
        db = try Connection(databasePath)
    }
    
    // MARK: - Thirukural Queries
    
    /// Returns the number of rows in the thirukural table.
    func getThirukuralCount() throws -> Int {
        return try Int(db.scalar(thirukuralTable.count))
    }
    
    /// Fetches all Thirukural entries.
    func getAllThirukurals() throws -> [ThirukuralData] {
        var results = [ThirukuralData]()
        for row in try db.prepare(thirukuralTable) {
            results.append(ThirukuralData(
                id: row[idExp],
                kuralNumber: row[kuralNumberExp],
                verse: row[verseExp],
                combinedExplanation: row[combinedExplanationExp],
                explanation: row[explanationExp],
                storyTitle: row[storyTitleExp],
                storyContent: row[storyContentExp],
                storyMoral: row[storyMoralExp]
            ))
        }
        return results
    }
    
    /// Fetches a single Thirukural by its primary key.
    func getThirukuralById(_ idValue: Int64) throws -> ThirukuralData? {
        let query = thirukuralTable.filter(idExp == idValue)
        if let row = try db.pluck(query) {
            return ThirukuralData(
                id: row[idExp],
                kuralNumber: row[kuralNumberExp],
                verse: row[verseExp],
                combinedExplanation: row[combinedExplanationExp],
                explanation: row[explanationExp],
                storyTitle: row[storyTitleExp],
                storyContent: row[storyContentExp],
                storyMoral: row[storyMoralExp]
            )
        }
        return nil
    }
    
    // MARK: - WordMeaning Queries
    
    /// Fetches all Word Meanings for a given Thirukural ID, ordered by position.
    func getWordMeaningsByThirukuralId(_ thirukuralId: Int64) throws -> [WordMeaningData] {
        var results = [WordMeaningData]()
        let query = wordMeaningsTable.filter(wmThirukuralIdExp == thirukuralId).order(wmPositionExp)
        for row in try db.prepare(query) {
            results.append(WordMeaningData(
                id: row[wmIdExp],
                thirukuralId: row[wmThirukuralIdExp],
                position: row[wmPositionExp],
                term: row[termExp],
                transliteration: row[transliterationExp],
                meaning: row[meaningExp]
            ))
        }
        return results
    }
    
    /// Fetches Word Meanings where the term starts with a given prefix (case insensitive).
    func getWordMeaningsByTerm(_ termPrefix: String) throws -> [WordMeaningData] {
        var results = [WordMeaningData]()
        let pattern = termPrefix.lowercased() + "%"
        // Using LIKE with the assumption that the database collation is case-insensitive.
        let query = wordMeaningsTable.filter(termExp.like(pattern))
        for row in try db.prepare(query) {
            results.append(WordMeaningData(
                id: row[wmIdExp],
                thirukuralId: row[wmThirukuralIdExp],
                position: row[wmPositionExp],
                term: row[termExp],
                transliteration: row[transliterationExp],
                meaning: row[meaningExp]
            ))
        }
        return results
    }
    
    /// Fetches Word Meanings where the transliteration starts with a given prefix (case insensitive).
    func getWordMeaningByTransliteration(_ transliterationPrefix: String) throws -> [WordMeaningData] {
        var results = [WordMeaningData]()
        let pattern = transliterationPrefix.lowercased() + "%"
        let query = wordMeaningsTable.filter(transliterationExp.like(pattern))
        for row in try db.prepare(query) {
            results.append(WordMeaningData(
                id: row[wmIdExp],
                thirukuralId: row[wmThirukuralIdExp],
                position: row[wmPositionExp],
                term: row[termExp],
                transliteration: row[transliterationExp],
                meaning: row[meaningExp]
            ))
        }
        return results
    }
    
    /// Fetches Word Meanings where the meaning starts with a given prefix (case insensitive).
    func getWordMeaningByMeaning(_ meaningPrefix: String) throws -> [WordMeaningData] {
        var results = [WordMeaningData]()
        let pattern = meaningPrefix.lowercased() + "%"
        let query = wordMeaningsTable.filter(meaningExp.like(pattern))
        for row in try db.prepare(query) {
            results.append(WordMeaningData(
                id: row[wmIdExp],
                thirukuralId: row[wmThirukuralIdExp],
                position: row[wmPositionExp],
                term: row[termExp],
                transliteration: row[transliterationExp],
                meaning: row[meaningExp]
            ))
        }
        return results
    }
    
    // MARK: - Theme Queries
    
    /// Fetches all Themes for a given Thirukural ID.
    func getThemesByThirukuralId(_ thirukuralId: Int64) throws -> [ThemeData] {
        var results = [ThemeData]()
        let query = themesTable.filter(themeThirukuralIdExp == thirukuralId)
        for row in try db.prepare(query) {
            results.append(ThemeData(
                id: row[themeIdExp],
                thirukuralId: row[themeThirukuralIdExp],
                theme: row[themeExp]
            ))
        }
        return results
    }
    
    /// Fetches Themes where the theme string starts with a given prefix (case insensitive).
    func getThemesByTheme(_ themePrefix: String) throws -> [ThemeData] {
        var results = [ThemeData]()
        let pattern = themePrefix.lowercased() + "%"
        let query = themesTable.filter(themeExp.like(pattern))
        for row in try db.prepare(query) {
            results.append(ThemeData(
                id: row[themeIdExp],
                thirukuralId: row[themeThirukuralIdExp],
                theme: row[themeExp]
            ))
        }
        return results
    }
    
    // MARK: - Composite Queries
    
    /// Fetches a Thirukural (by its kural_number) along with its Word Meanings and Themes.
    func getThirukuralWithDetails(kuralNumber: Int) throws -> ThirukuralWithDetails {
        let query = thirukuralTable.filter(kuralNumberExp == kuralNumber)
        guard let thirukuralRow = try db.pluck(query) else {
            throw DataError.invalidInput(reason: "Invalid input \(kuralNumber)")
        }
        let thirukural = ThirukuralData(
            id: thirukuralRow[idExp],
            kuralNumber: thirukuralRow[kuralNumberExp],
            verse: thirukuralRow[verseExp],
            combinedExplanation: thirukuralRow[combinedExplanationExp],
            explanation: thirukuralRow[explanationExp],
            storyTitle: thirukuralRow[storyTitleExp],
            storyContent: thirukuralRow[storyContentExp],
            storyMoral: thirukuralRow[storyMoralExp]
        )
        guard let tid = thirukural.id else {
            throw DataError.invalidInput(reason: "Invalid match \(kuralNumber)")
        }
        let wordMeanings = try getWordMeaningsByThirukuralId(tid)
        let themes = try getThemesByThirukuralId(tid)
        return ThirukuralWithDetails(thirukural: thirukural, wordMeanings: wordMeanings, themes: themes)
    }
    
    /// Fetches a Thirukural (by its primary key) along with its Word Meanings and Themes.
    func getThirukuralWithDetailsFromId(_ idValue: Int64) throws -> ThirukuralWithDetails? {
        guard let thirukural = try getThirukuralById(idValue) else { return nil }
        let wordMeanings = try getWordMeaningsByThirukuralId(idValue)
        let themes = try getThemesByThirukuralId(idValue)
        return ThirukuralWithDetails(thirukural: thirukural, wordMeanings: wordMeanings, themes: themes)
    }
    
    // MARK: - Additional Thirukural Queries (Filtering by Text)
    
    /// Fetches Thirukural entries where the verse begins with the given prefix (case insensitive).
    func getThirukuralByVerse(_ versePrefix: String) throws -> [ThirukuralData] {
        var results = [ThirukuralData]()
        let pattern = versePrefix.lowercased() + "%"
        let query = thirukuralTable.filter(verseExp.like(pattern))
        for row in try db.prepare(query) {
            results.append(ThirukuralData(
                id: row[idExp],
                kuralNumber: row[kuralNumberExp],
                verse: row[verseExp],
                combinedExplanation: row[combinedExplanationExp],
                explanation: row[explanationExp],
                storyTitle: row[storyTitleExp],
                storyContent: row[storyContentExp],
                storyMoral: row[storyMoralExp]
            ))
        }
        return results
    }
    
    /// Fetches Thirukural entries where the combined explanation begins with the given query (case insensitive).
    func getThirukuralByCombinedExplanation(_ queryStr: String) throws -> [ThirukuralData] {
        var results = [ThirukuralData]()
        let pattern = queryStr.lowercased() + "%"
        let query = thirukuralTable.filter(combinedExplanationExp.like(pattern))
        for row in try db.prepare(query) {
            results.append(ThirukuralData(
                id: row[idExp],
                kuralNumber: row[kuralNumberExp],
                verse: row[verseExp],
                combinedExplanation: row[combinedExplanationExp],
                explanation: row[explanationExp],
                storyTitle: row[storyTitleExp],
                storyContent: row[storyContentExp],
                storyMoral: row[storyMoralExp]
            ))
        }
        return results
    }
    
    /// Fetches Thirukural entries where the explanation begins with the given query (case insensitive).
    func getThirukuralByExplanation(_ queryStr: String) throws -> [ThirukuralData] {
        var results = [ThirukuralData]()
        let pattern = queryStr.lowercased() + "%"
        let query = thirukuralTable.filter(explanationExp.like(pattern))
        for row in try db.prepare(query) {
            results.append(ThirukuralData(
                id: row[idExp],
                kuralNumber: row[kuralNumberExp],
                verse: row[verseExp],
                combinedExplanation: row[combinedExplanationExp],
                explanation: row[explanationExp],
                storyTitle: row[storyTitleExp],
                storyContent: row[storyContentExp],
                storyMoral: row[storyMoralExp]
            ))
        }
        return results
    }
    
    /// Fetches Thirukural entries where the story title begins with the given query (case insensitive).
    func getThirukuralByStoryTitle(_ queryStr: String) throws -> [ThirukuralData] {
        var results = [ThirukuralData]()
        let pattern = queryStr.lowercased() + "%"
        let query = thirukuralTable.filter(storyTitleExp.like(pattern))
        for row in try db.prepare(query) {
            results.append(ThirukuralData(
                id: row[idExp],
                kuralNumber: row[kuralNumberExp],
                verse: row[verseExp],
                combinedExplanation: row[combinedExplanationExp],
                explanation: row[explanationExp],
                storyTitle: row[storyTitleExp],
                storyContent: row[storyContentExp],
                storyMoral: row[storyMoralExp]
            ))
        }
        return results
    }
    
    /// Fetches Thirukural entries where the story content begins with the given query (case insensitive).
    func getThirukuralByStoryContent(_ queryStr: String) throws -> [ThirukuralData] {
        var results = [ThirukuralData]()
        let pattern = queryStr.lowercased() + "%"
        let query = thirukuralTable.filter(storyContentExp.like(pattern))
        for row in try db.prepare(query) {
            results.append(ThirukuralData(
                id: row[idExp],
                kuralNumber: row[kuralNumberExp],
                verse: row[verseExp],
                combinedExplanation: row[combinedExplanationExp],
                explanation: row[explanationExp],
                storyTitle: row[storyTitleExp],
                storyContent: row[storyContentExp],
                storyMoral: row[storyMoralExp]
            ))
        }
        return results
    }
    
    /// Fetches Thirukural entries where the story moral begins with the given query (case insensitive).
    func getThirukuralByStoryMoral(_ queryStr: String) throws -> [ThirukuralData] {
        var results = [ThirukuralData]()
        let pattern = queryStr.lowercased() + "%"
        let query = thirukuralTable.filter(storyMoralExp.like(pattern))
        for row in try db.prepare(query) {
            results.append(ThirukuralData(
                id: row[idExp],
                kuralNumber: row[kuralNumberExp],
                verse: row[verseExp],
                combinedExplanation: row[combinedExplanationExp],
                explanation: row[explanationExp],
                storyTitle: row[storyTitleExp],
                storyContent: row[storyContentExp],
                storyMoral: row[storyMoralExp]
            ))
        }
        return results
    }
}
