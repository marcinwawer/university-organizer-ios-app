//
//  DeveloperPreview.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 21/11/2024.
//

import Foundation

class DeveloperPreview {
    static let shared = DeveloperPreview()
    private init() {}
    
    let userVM = UserViewModel()
    let planVM = PlanViewModel()
    let subject = Subject(name: "Cybersecurity Cybersecurity Cybersecurity Cybersecurity", type: SubjectType.lecture, room: "200", building: "D-1")
}
