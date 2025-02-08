//
//  TKuralTheme.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//

import SwiftUI

struct TKuralTheme<Content: View>: View {
    @Environment(\.colorScheme) var systemColorScheme
    let content: () -> Content // Fix: Explicitly define the closure return type

    var colorScheme: ColorScheme {
        return systemColorScheme == .dark ? TKuralColorScheme.dark : TKuralColorScheme.light
    }

    var body: some View {
        content() // Fix: Call the closure explicitly
            .background(colorScheme.background)
            .foregroundColor(colorScheme.onBackground)
    }
}
