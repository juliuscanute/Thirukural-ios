//
//  ContentView.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TKuralTheme {
            VStack {
                Text("Hello, TKural!")
                    .font(.largeTitle)
                    .padding()
                    .background(TKuralColors.purple40) // Ensure purple40 exists in TKuralColors
                    .foregroundColor(TKuralColorScheme.light.onPrimary) // Fixed onPrimary reference
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
