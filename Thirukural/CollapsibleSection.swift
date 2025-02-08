//
//  CollapsibleSection.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//

import Foundation

import SwiftUI

struct CollapsibleSection<Content: View>: View {
    let title: String
    let isExpanded: Bool
    let onExpand: () -> Void
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.headline)
                    .padding(.vertical, 8)
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .onTapGesture {
                        onExpand()
                    }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onExpand()
            }
            
            if isExpanded {
                content()
                    .padding(.top, 8)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}
