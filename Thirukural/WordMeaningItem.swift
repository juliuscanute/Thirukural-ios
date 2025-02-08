//
//  WordMeaningItem.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//

import SwiftUI

struct WordMeaningItem: View {
    let meanings: [WordMeaningViewState]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(meanings, id: \.index) { meaning in
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(meaning.index). \(meaning.term) (\(meaning.transliteration))")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    Text(meaning.meaning)
                        .font(.body)
                }
                .padding(.bottom, 8)
            }
        }
    }
}
