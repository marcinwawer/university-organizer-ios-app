//
//  SingleNoteView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 16/12/2024.
//

import SwiftUI

struct SingleNoteView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.title)
                .font(.title3)
                .lineLimit(2)
            
            Text(note.subject.name)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.bottom)
                .lineLimit(1)
            
            Text(note.content)
                .font(.subheadline)
            
            Spacer()
        }
        .frame(width: 180, height: 240)
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(note.subject.getColor()?.opacity(0.8) ?? Color.theme.background)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .customShadow()
    }
}

#Preview {
    SingleNoteView(note: DeveloperPreview.shared.note)
}
