//
//  MaterialButtonStyle.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//

import SwiftUI

struct MaterialButtonStyle: ButtonStyle {
    var colorScheme: ColorScheme
    
    // Read the environment's isEnabled value
    @Environment(\.isEnabled) private var isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                // Use a different background based on the disabled state.
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        !isEnabled ? colorScheme.tertiary : // Use tertiary color when disabled
                        configuration.isPressed ? colorScheme.secondary : // Change on press
                        colorScheme.primary
                    )
            )
            .foregroundColor(
                // Change text color depending on whether the button is disabled.
                !isEnabled ? colorScheme.onTertiary : colorScheme.onSurface
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
