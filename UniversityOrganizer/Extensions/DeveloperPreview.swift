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
        
        mark = Mark(pointsGot: 5, pointsMax: 10, subject: subject, date: Date().addingTimeInterval(-86400))
        mark2 = Mark(pointsGot: 0, pointsMax: 10, subject: subject)
        mark3 = Mark(pointsGot: 2, pointsMax: 10, subject: subject, date: Date().addingTimeInterval(-86400 * 50))
        mark4 = Mark(pointsGot: 10, pointsMax: 10, subject: subject, date: Date().addingTimeInterval(-86400 * 10))
        marks = [mark, mark2, mark3, mark4].sorted { $0.date < $1.date }
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
    
    let mark: Mark
    let mark2: Mark
    let mark3: Mark
    let mark4: Mark
    let marks: [Mark]
}
