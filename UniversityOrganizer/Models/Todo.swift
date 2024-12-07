//
//  Todo.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 07/12/2024.
//

import Foundation
import SwiftData

@Model
class Todo {
    var id = UUID()
    var title: String
    var isDone: Bool
    var dueDate: Date?
    var subject: Subject
    
    init(title: String, isDone: Bool = false, subject: Subject, dueDate: Date? = nil) {
        self.title = title
        self.isDone = isDone
        self.subject = subject
        self.dueDate = dueDate
    }
}
