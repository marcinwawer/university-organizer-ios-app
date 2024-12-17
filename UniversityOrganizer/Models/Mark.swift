//
//  Mark.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 17/12/2024.
//

import Foundation
import SwiftData

@Model
class Mark {
    var id = UUID()
    var pointsGot: Double
    var pointsMax: Double
    var subject: Subject
    
    init(pointsGot: Double, pointsMax: Double, subject: Subject) {
        self.pointsGot = pointsGot
        self.pointsMax = pointsMax
        self.subject = subject
    }
}
