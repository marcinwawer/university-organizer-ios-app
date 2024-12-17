//
//  EmptyNotesView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 17/12/2024.
//

import SwiftUI

struct EmptyNotesView: View {
    var body: some View {
        Image(systemName: "text.page.slash.fill")
            .resizable()
            .frame(width: 50, height: 50)
            .foregroundStyle(.secondary)
        
        Text("There are no notes! 😭")
            .font(.title)
            .fontWeight(.semibold)
    }
}

#Preview {
    EmptyNotesView()
}
