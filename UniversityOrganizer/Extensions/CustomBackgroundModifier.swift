//
//  CustomBackgroundModifier.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 03/11/2024.
//

import SwiftUI

struct CustomBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .opacity(0.6)
            .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 40, bottomTrailingRadius: 40))
            .ignoresSafeArea()
    }
}

extension View {
    func customBackground() -> some View {
        self.modifier(CustomBackgroundModifier())
    }
}
