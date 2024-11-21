//
//  HomeView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 03/11/2024.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(UserViewModel.self) private var vm
    
    @Binding var activeTab: TabModel
    @Binding var checkWelcomeView: Bool
    
    @State private var showPreferencesView = false
    
    var safeAreaInsets: EdgeInsets
    
    var body: some View {
        ScrollView {
            VStack() {
                header
                    .padding(.bottom, 4)
                
                universityInfo
                
                userInfo
                    .padding(.top)
            }
            .padding()
            .padding(.top, safeAreaInsets.top)
            .background(GradientBackground())
            
            newsView(text: "X tasks to complete") // TODO: vm
                .padding(.leading)
                .foregroundStyle(Color.theme.green)
                .onTapGesture {
                    activeTab = .tasks
                }
            
            newsView(text: "X deadlines this week") // TODO: vm
                .padding(.leading)
                .foregroundStyle(Color.theme.red)
                .onTapGesture {
                    activeTab = .tasks
                }
            
            newsView(text: "X new marks last week") // TODO: vm
                .padding(.leading)
                .foregroundStyle(Color.theme.blue)
                .onTapGesture {
                    activeTab = .marks
                }
            
            upcomingClassSection
            
            gpaSection
            
            Spacer()
        }
        .sheet(isPresented: $showPreferencesView) {
            NavigationStack {
                PreferencesView(checkWelcomeView: $checkWelcomeView)
            }
        }
        .scrollIndicators(.hidden)
        .safeAreaPadding(.bottom, 100)
        .ignoresSafeArea()
    }
    
    func newsView(text: String) -> some View {
        HStack {
            Image(systemName: "circle.fill")
                .font(.caption)
            
            Text(text)
            
            Spacer()
        }
    }
}

#Preview {
    GeometryReader { geo in
        HomeView(activeTab: .constant(TabModel.home), checkWelcomeView: .constant(true), safeAreaInsets: geo.safeAreaInsets)
            .environment(DeveloperPreview.shared.userVM)
    }
}

extension HomeView {
    private var header: some View {
        HStack {
            Image(systemName: "slider.horizontal.3")
                .font(.title)
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                .onTapGesture {
                    showPreferencesView = true
                }
            
            Spacer()
            
            Text("Hi, \(vm.name) 🚀")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Spacer()
        }
    }
    
    private var universityInfo: some View {
        Group {
            Text(vm.university)
            Text(vm.degree)
        }
        .font(.callout)
        .foregroundStyle(.secondary)
        .lineLimit(1)
    }
    
    private var userInfo: some View {
        HStack() {
            Circle()
                .frame(width: 100, height: 100)
                .padding(.trailing)
            
            VStack(alignment: .leading) {
                Text("\(vm.name) \(vm.surname)")
                Text("Student, \(vm.academicYear) year")
                Text(vm.index)
            }
            .foregroundStyle(.secondary)
            .font(.callout)
            
            
            Spacer()
        }
    }
    
    private var gpaSection : some View {
        VStack {
            HStack {
                Image(systemName: "chart.pie")
                Text("Summary")
                Spacer()
            }
            .padding()
            .font(.title)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.theme.background)
                    .customShadow()
                
                VStack() {
                    Text("Current GPA")
                        .foregroundStyle(.secondary)
                        .padding(.top)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "graduationcap.circle")
                        Text("4.20")
                    }
                    
                    Spacer()
                }
                .font(.title3)
                .fontWeight(.semibold)
                .padding()
            }
            .padding(.horizontal, 40)
            .onTapGesture {
                activeTab = .marks
            }
        }
    }
    
    private var upcomingClassSection : some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "calendar.circle")
                Text("Upcoming class")
                Spacer()
            }
            .padding()
            .font(.title)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.theme.background)
                    .customShadow()
                
                VStack(alignment: .leading) {
                    Text("Cybersecurity Lab") //TODO: vm
                        .font(.title2)
                    
                    Spacer()
                    
                    Text("Friday, 14 October") //TODO: vm
                    
                    HStack {
                        Image(systemName: "timer.circle")
                        Text("10:00 - 12:00") //TODO: vm
                    }
                    
                    HStack {
                        Image(systemName: "timer.circle")
                        Text("Z-7, 188") //TODO: vm
                    }
                }
                .padding()
                .lineLimit(1)
            }
            .padding(.horizontal, 40)
            .onTapGesture {
                activeTab = .plan
            }
        }
    }
    
}
