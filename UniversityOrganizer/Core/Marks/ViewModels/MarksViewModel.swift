//
//  MarksViewModel.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 17/12/2024.
//

import Foundation
import SwiftData

@Observable class MarksViewModel {
    var marks: [Mark] = []
    
    init(marks: [Mark]) {
        self.marks = marks
    }
    
    func getMarksForSubject(subject: Subject) -> [Mark] {
        return marks.filter { $0.subject == subject }
    }
    
    func deleteMark(at offsets: IndexSet, context: ModelContext) {
        for index in offsets {
            let mark = marks[index]
            context.delete(mark)
            marks.remove(at: index)
        }
        try? context.save()
    }
}
