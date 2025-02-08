//
//  TKuralColors.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (default alpha 255)
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8: // ARGB
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0) // Default to black on error
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct TKuralColors {
    static let purple80 = Color(hex: "#D0BCFF")
    static let purpleGrey80 = Color(hex: "#CCC2DC")
    static let pink80 = Color(hex: "#EFB8C8")
    
    static let purple40 = Color(hex: "#6650A4")
    static let purpleGrey40 = Color(hex: "#625B71")
    static let pink40 = Color(hex: "#7D5260")
    
    static let blue80 = Color(hex: "#80D8FF")
    static let blue40 = Color(hex: "#0077C2")
    
    static let green80 = Color(hex: "#B9FBC0")
    static let green40 = Color(hex: "#388E3C")
    
    static let yellow80 = Color(hex: "#FFF59D")
    static let yellow40 = Color(hex: "#FBC02D")
    
    static let red80 = Color(hex: "#FF8A80")
    static let red40 = Color(hex: "#D32F2F")
}
