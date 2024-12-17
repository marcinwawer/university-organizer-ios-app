//
//  EmptyMarksView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 17/12/2024.
//

import SwiftUI

struct EmptyMarksView: View {
    var body: some View {
        Image(systemName: "plus.forwardslash.minus")
            .resizable()
            .frame(width: 50, height: 50)
            .foregroundStyle(.secondary)
        
        Text("There are no marks! 🤯")
            .font(.title)
            .fontWeight(.semibold)
    }
}

#Preview {
    EmptyMarksView()
}
