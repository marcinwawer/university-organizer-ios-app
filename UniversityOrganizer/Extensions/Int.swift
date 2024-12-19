//
//  Int.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 26/11/2024.
//

import Foundation

extension Int {
    func dayOfWeek() -> String? {
        let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        
        guard self >= 0 && self < daysOfWeek.count else { return nil }
        return daysOfWeek[self]
    }
}
