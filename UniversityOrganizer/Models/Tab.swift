//
//  Tab.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 03/11/2024.
//

import SwiftUI

enum TabModel: String, CaseIterable {
    case home = "house"
    case tasks = "list.bullet"
    case notes = "note.text"
    case marks = "graduationcap"
    case plan = "calendar"
    
    var title: String {
        switch self {
            case .home: return "Home"
            case .tasks: return "Tasks"
            case .notes: return "Notes"
            case .marks: return "Marks"
            case .plan: return "Plan"
        }
    }
}
