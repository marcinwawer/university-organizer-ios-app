//
//  ContentView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 03/11/2024.
//

// safeAreaPadding(.bottom, 60) !

import SwiftUI

struct ContentView: View {
    @State private var activeTab: TabModel = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $activeTab) {
                Tab.init(value: .home) {
                    Text("Home")
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
                
                Tab.init(value: .tasks) {
                    Text("Tasks")
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
                
                Tab.init(value: .notes) {
                    Text("Notes")
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
                
                Tab.init(value: .marks) {
                    Text("Marks")
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
                
                Tab.init(value: .plan) {
                    Text("Plan ")
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
            }
            
            CustomTabBar(activeTab: $activeTab)
        }
    }
}

#Preview {
    ContentView()
}


