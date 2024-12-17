//
//  MarksViewModel.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 17/12/2024.
//

import Foundation

@Observable class MarksViewModel {
    var marks: [Mark] = []
    
    init(marks: [Mark]) {
        self.marks = marks
    }
    
    func getMarksForSubject(subject: Subject) -> [Mark] {
        return marks.filter { $0.subject == subject }
    }
}
