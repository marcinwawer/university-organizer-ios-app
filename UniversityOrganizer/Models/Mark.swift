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
    var percentage: Double {
        guard pointsMax > 0 else { return 0.0 }
        
        let percent = (pointsGot / pointsMax) * 100
        return Double(round(100 * percent) / 100)
    }
    var date: Date
    
    init(pointsGot: Double, pointsMax: Double, subject: Subject, date: Date = Date()) {
        self.pointsGot = pointsGot
        self.pointsMax = pointsMax
        self.subject = subject
        self.date = date
    }
}
