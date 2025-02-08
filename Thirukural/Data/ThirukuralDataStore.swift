//
//  ThirukuralDataStore.swift
//  Thirukural
//
//  Created by Julius Canute on 8/2/2025.
//

import Foundation
import Combine

class ThirukuralDataStore {
    private let kuralNumberKey = "kural_number"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func saveKuralNumber(_ kuralNumber: Int) {
        defaults.set(kuralNumber, forKey: kuralNumberKey)
    }
    
    func getKuralNumber() -> Int {
        let number = defaults.integer(forKey: kuralNumberKey)
        return number == 0 ? 1 : number
    }
}
