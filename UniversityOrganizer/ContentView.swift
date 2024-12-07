//
//  ContentView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 03/11/2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("showWelcomeView") private var showWelcomeView = true
    
    @State private var checkWelcomeView = true
    @State private var activeTab: TabModel = .home
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                ZStack(alignment: .bottom) {
                    TabView(selection: $activeTab) {
                        Tab.init(value: .home) {
                            HomeView(activeTab: $activeTab, checkWelcomeView: $checkWelcomeView, safeAreaInsets: geo.safeAreaInsets)
                                .toolbarVisibility(.hidden, for: .tabBar)
//                                .ignoresSafeArea(.keyboard) ??? moze byc potrzebne do chowania tabbar przy pisaniu ???
                        }
                        
                        Tab.init(value: .tasks) {
                            TasksView()
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
                            PlanView()
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                    }
                    
                    CustomTabBar(activeTab: $activeTab)
                }
            }
            .opacity(checkWelcomeView ? 0 : 1)
            .animation(.easeIn, value: checkWelcomeView)
            
            if checkWelcomeView {
                NavigationStack {
                    WelcomeView(checkWelcomeView: $checkWelcomeView)
                        .opacity(checkWelcomeView ? 1 : 0)
                        .animation(.easeOut, value: checkWelcomeView)
                        .zIndex(1)
                }
            }
        }
        .onAppear {
            checkWelcomeView = showWelcomeView
        }
    }
}
