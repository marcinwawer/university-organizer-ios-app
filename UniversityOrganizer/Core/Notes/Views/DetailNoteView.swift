//
//  DetailNoteView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 16/12/2024.
//

import SwiftUI

struct DetailNoteView: View {
    @Environment(\.dismiss) private var dismiss
    
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.title)
                .font(.title)
                .lineLimit(2)
                .padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(note.content)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle(note.subject.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                XMarkButton()
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
        .background(note.subject.getColor()?.opacity(0.8) ?? Color.theme.background)
    }
}

#Preview {
    NavigationStack {
        DetailNoteView(note: DeveloperPreview.shared.note)
    }
}
