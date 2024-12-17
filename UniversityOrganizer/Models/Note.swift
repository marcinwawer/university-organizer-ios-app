//
//  Note.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 16/12/2024.
//

import Foundation
import SwiftData

@Model
class Note {
    var id = UUID()
    var title: String
    var content: String
    var subject: Subject
    
    init(title: String, content: String, subject: Subject) {
        self.title = title
        self.content = content
        self.subject = subject
    }
}
