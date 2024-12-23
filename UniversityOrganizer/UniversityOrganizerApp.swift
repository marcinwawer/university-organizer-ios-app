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
    @AppStorage("showWelcomeView") private var showWelcomeView = true
    
    @State private var vm = UserViewModel()
    @State private var planVM = PlanViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: checkTestingFlags)
                .environment(vm)
                .environment(planVM)
                .modelContainer(for: [Subject.self, Todo.self, Note.self, Mark.self])
                .preferredColorScheme(appearance.colorScheme)
        }
    }
}

// MARK: FUNCTIONS
extension UniversityOrganizerApp {
    private func checkTestingFlags() {
        if CommandLine.arguments.contains("--uitesting-showWelcomeView-false") {
            showWelcomeView = false
        }
        
        if CommandLine.arguments.contains("--uitesting-showWelcomeView-true") {
            showWelcomeView = true
        }
        
        if CommandLine.arguments.contains("--uitesting-appearance-light") {
            appearance = .light
        }
    }
}
