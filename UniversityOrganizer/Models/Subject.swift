//
//  Subject.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 21/11/2024.
//

import SwiftData
import SwiftUI

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
    var colorHex: String?
    
    init(name: String, type: SubjectType, room: String? = nil, building: String? = nil, color: Color? = nil) {
        self.name = name
        self.type = type.rawValue
        self.room = room
        self.building = building
        self.colorHex = color?.toHex()
    }
    
    func getColor() -> Color? {
        guard let hex = colorHex else { return nil }
        return Color(hex: hex)
    }
    
    func setColor(_ color: Color) {
        self.colorHex = color.toHex()
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

