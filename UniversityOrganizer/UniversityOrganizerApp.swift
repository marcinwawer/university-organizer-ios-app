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
    @AppStorage("appearance") private var appearance: Appearance = .light
    @State private var vm = UserViewModel()
    @State private var planVM = PlanViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(vm)
                .environment(planVM)
                .modelContainer(for: Subject.self)
                .preferredColorScheme(appearance.colorScheme)
        }
    }
}
