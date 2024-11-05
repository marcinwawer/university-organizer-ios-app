//
//  CustomShadowModifier.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 03/11/2024.
//

import SwiftUI

struct CustomShadowModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: colorScheme == .dark ? .white.opacity(0.1) : .black.opacity(0.1),
                radius: 8
            )
    }
}

extension View {
    func customShadow() -> some View {
        self.modifier(CustomShadowModifier())
    }
}
