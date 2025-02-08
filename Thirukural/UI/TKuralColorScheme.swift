//
//  TKuralColorScheme.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//
import SwiftUI

struct ColorScheme {
    var primary: Color
    var secondary: Color
    var tertiary: Color
    var background: Color
    var surface: Color
    var onPrimary: Color
    var onSecondary: Color
    var onTertiary: Color
    var onBackground: Color
    var onSurface: Color
}

struct TKuralColorScheme {
    static let dark = ColorScheme(
        primary: TKuralColors.purple80,
        secondary: TKuralColors.purpleGrey80,
        tertiary: TKuralColors.pink80,
        background: TKuralColors.blue40,
        surface: TKuralColors.green40,
        onPrimary: TKuralColors.yellow80,
        onSecondary: TKuralColors.red80,
        onTertiary: TKuralColors.green80,
        onBackground: Color.white,
        onSurface: Color.white
    )
    
    static let light = ColorScheme(
        primary: TKuralColors.purple40,
        secondary: TKuralColors.purpleGrey40,
        tertiary: TKuralColors.pink40,
        background: TKuralColors.blue80,
        surface: TKuralColors.green80,
        onPrimary: TKuralColors.yellow40,
        onSecondary: TKuralColors.red40,
        onTertiary: TKuralColors.green40,
        onBackground: Color.black,
        onSurface: Color.black
    )
}
