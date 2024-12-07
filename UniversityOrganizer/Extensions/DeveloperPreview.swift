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
        subjects = [subject]
        todo = Todo(title: "Do something", isDone: false, subject: subject)
        done = Todo(title: "Do something", isDone: true, subject: subject)
        deadline = Todo(title: "Do something", isDone: false, subject: subject, dueDate: Date())
    }
    
    let userVM = UserViewModel()
    let planVM = PlanViewModel()
    let subject = Subject(name: "Cybersecurity Cybersecurity", type: SubjectType.lecture, room: "200", building: "D-1", color: Color.blue)
    let subjects: [Subject]
    let todo: Todo
    let deadline: Todo
    let done: Todo
    let tasksVM = TasksViewModel(tasks: [])
}
