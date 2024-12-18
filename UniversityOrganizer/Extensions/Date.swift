//
//  Date.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 18/12/2024.
//

import Foundation

extension Date {
    func strippedTime() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self) 
    }
}
