//
//  NotesViewModel.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 16/12/2024.
//

import Foundation
import SwiftData

@Observable class NotesViewModel {
    var notes: [Note] = []
    
    init(notes: [Note]) {
        self.notes = notes
    }
    
    func addNote(context: ModelContext, title: String, subject: Subject?, content: String) {
        guard let subject = subject else {
            return
        }
        
        let note = Note(title: title, content: content, subject: subject)
        context.insert(note)
        
        do {
            try context.save()
        } catch {
            print("error saving note: \(error)")
        }
    }
    
    func getNotesForSubject(subject: Subject) -> [Note] {
        return notes.filter { $0.subject == subject }
    }
    
    func deleteNote(context: ModelContext, note: Note) {
        context.delete(note)
        
        do {
            try context.save()
        } catch {
            print("error deleting note: \(error)")
        }
    }
}
