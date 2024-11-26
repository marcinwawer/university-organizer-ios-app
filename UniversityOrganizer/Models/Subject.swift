//
//  Subject.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 21/11/2024.
//

import SwiftData
import Foundation

enum SubjectType: String, Codable, CaseIterable {
    case lecture = "W"
    case project = "P"
    case practical = "Ć"
    case laboratory = "L"
    case seminary = "S"
    
    static func from(character: Character) -> SubjectType? {
        return SubjectType.allCases.first { $0.rawValue == String(character) }
    }
}

@Model
class Subject: Identifiable {
    var id = UUID()
    var name: String
    var type: String
    var schedules: [Schedule] = []
    var room: String?
    var building: String?
    
    init(name: String, type: SubjectType, room: String? = nil, building: String? = nil) {
        self.name = name
        self.type = type.rawValue
        self.room = room
        self.building = building
    }
}

@Model
class Schedule {
    var startTime: String
    var endTime: String
    var dayOfTheWeek: Int
    
    init(startTime: String, endTime: String, dayOfTheWeek: Int) {
        self.startTime = startTime
        self.endTime = endTime
        self.dayOfTheWeek = dayOfTheWeek
    }
}

