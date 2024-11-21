//
//  UniversityOrganizerApp.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 24-10-2024.
//

import SwiftUI
import SwiftData

@main
struct UniversityOrganizerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Subject.self)
        }
    }
}
