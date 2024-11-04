//
//  GradientBackground.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 04/11/2024.
//

import SwiftUI

struct GradientBackground: View {
    var body: some View {
        GeometryReader { geo in
            let offsetY = geo.frame(in: .global).minY
            let isScrolled = offsetY > 0
            let height = geo.size.height
            
            Spacer()
                .frame(height: isScrolled ? height + offsetY : height)
                .background {
                    LinearGradient.customGradient
                        .opacity(0.6)
                        .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 40, bottomTrailingRadius: 40))
                        .offset(y: isScrolled ? -offsetY : 0)
                }
        }
    }
}

#Preview {
    GradientBackground()
}
