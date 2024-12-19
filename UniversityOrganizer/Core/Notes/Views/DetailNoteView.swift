//
//  DetailNoteView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 16/12/2024.
//

import SwiftUI
import SwiftData

struct DetailNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    let note: Note
    
    @State var vm: NotesViewModel
    
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
            
            deleteNoteButton.frame(maxWidth: .infinity, alignment: .center)
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

// MARK: VARIABLES
extension DetailNoteView {
    private var deleteNoteButton: some View {
        Button {
            vm.deleteNote(context: context, note: note)
            dismiss()
        } label: {
            HStack {
                Image(systemName: "minus.circle")
                Text("Delete Note")
            }
            .foregroundStyle(Color.theme.red)
        }
    }
}

#Preview {
    NavigationStack {
        DetailNoteView(note: DeveloperPreview.shared.note, vm: DeveloperPreview.shared.notesVM)
    }
}
