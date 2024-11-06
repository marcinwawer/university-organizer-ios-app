//
//  XMarkButton.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 04/11/2024.
//

import SwiftUI

struct XMarkButton: View {
    var body: some View {
        Image(systemName: "xmark")
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.white)
            .padding(5)
            .background(.black.opacity(0.6))
            .clipShape(Circle())
    }
}

#Preview {
    XMarkButton()
}
