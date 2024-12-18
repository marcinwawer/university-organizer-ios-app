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
    
    func addMark(context: ModelContext, subject: Subject, pointsGot: Double, pointsMax: Double) {
        let mark = Mark(pointsGot: pointsGot, pointsMax: pointsMax, subject: subject)
        context.insert(mark)
        
        do {
            try context.save()
        } catch {
            print("error saving mark: \(error)")
        }
    }
    
    func isMarkValid(pointsGot: Double, pointsMax: Double) -> (Bool, String?) {
        if pointsGot > pointsMax {
            let communicate = "Number of points you got cannot be higher than maximum points!"
            return (false, communicate)
        }
        
        if pointsMax == 0 {
            let communicate = "Maximum number of points cannot be zero!"
            return (false, communicate)
        }
        
        return (true, nil)
    }
    
    func deleteMark(at offsets: IndexSet, context: ModelContext) {
        for index in offsets {
            let mark = marks[index]
            context.delete(mark)
            marks.remove(at: index)
        }
        try? context.save()
    }
    
    func formatPoints(_ points: Double) -> String {
        let roundedPoints = String(format: "%.2f", points)
        return roundedPoints.replacingOccurrences(of: "\\.?0+$", with: "", options: .regularExpression)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
    
    func getDoubleValue(_ strValue: String) -> Double {
        let normalizedValue = strValue.replacingOccurrences(of: ",", with: ".")
        if let value = Double(normalizedValue) {
            return value
        } else {
            return 0
        }
    }
}
