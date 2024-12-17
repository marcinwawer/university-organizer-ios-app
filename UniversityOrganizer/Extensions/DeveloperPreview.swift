//
//  DeveloperPreview.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 21/11/2024.
//

import SwiftUI

class DeveloperPreview {
    static let shared = DeveloperPreview()
    private init() {
        subjects = [subject, subject2]
        
        todo = Todo(title: "Do something", isDone: false, subject: subject)
        done = Todo(title: "Do something", isDone: true, subject: subject)
        deadline = Todo(title: "Do something", isDone: false, subject: subject, dueDate: Date())
        
        note = Note(title: "Do something", content: "agnfasklgjajsklfafgansf asjf ba sfb asfkjabs f", subject: subject)
        note2 = Note(title: "Test", content: "anfgbags aasfasfg afgjkashigas gdjsajbvdbhs  dh bgvdfbnvcdkfb cfvxfvbsdgoadsgndsbg ds", subject: subject)
        note3 = Note(title: "Witam", content: "asfasfas fasf jaj fgcdfvbmn fm", subject: subject2)
        notes = [note, note2, note3]
    }
    
    let userVM = UserViewModel()
    let planVM = PlanViewModel()
    let tasksVM = TasksViewModel(tasks: [])
    let notesVM = NotesViewModel(notes: [])
    
    let subject = Subject(name: "Cybersecurity", type: SubjectType.lecture, room: "200", building: "D-1", color: Color.blue)
    let subject2 = Subject(name: "Test Test", type: SubjectType.lecture, room: "150", building: "D-6", color: Color.red)
    let subjects: [Subject]
    
    let todo: Todo
    let deadline: Todo
    let done: Todo
    
    let note: Note
    let note2: Note
    let note3: Note
    let notes: [Note]
}
