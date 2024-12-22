//
//  HomeView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 03/11/2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var context
    @Environment(UserViewModel.self) private var userVM
    @Environment(PlanViewModel.self) private var planVM
    
    @Query(filter: #Predicate<Todo> { $0.dueDate == nil && !$0.isDone}) private var todos: [Todo]
    @Query(filter: #Predicate<Todo> { $0.dueDate != nil && !$0.isDone}) private var deadlines: [Todo]
    @Query(sort: \Mark.date) private var marks: [Mark]
    
    @Binding var activeTab: TabModel
    @Binding var checkWelcomeView: Bool
    
    @State private var showPreferencesView = false
    @State private var upcomingSubject: Subject?
    @State private var academicYear = AcademicYear.first
    
    var safeAreaInsets: EdgeInsets
    
    var body: some View {
        ScrollView {
            VStack() {
                header.padding(.bottom, 4)
                universityInfo
                userInfo.padding(.top)
            }
            .padding()
            .padding(.top, safeAreaInsets.top)
            .background(GradientBackground())
            
            let todosNum = todos.count
            newsView(text: todosNum == 0 ? "All tasks completed!" :
                        (todosNum == 1 ? "1 task to complete" : "\(todosNum) tasks to complete"))
            .padding(.leading)
            .foregroundStyle(Color.theme.green)
            
            let deadlinesNum = deadlines.count
            newsView(text: deadlinesNum == 0 ? "All deadlines completed!" :
                        (deadlinesNum == 1 ? "1 deadline to complete" : "\(deadlinesNum) deadlines to complete"))
            .padding(.leading)
            .foregroundStyle(Color.theme.red)
            
            let marksCount = MarksViewModel.marksFromLastWeek(marks: marks)
            newsView(text: marksCount == 0 ? "No new marks last week!" :
                        marksCount == 1 ? "1 new mark last week" : "\(marksCount) new marks last week")
            .padding(.leading)
            .foregroundStyle(Color.theme.blue)
            
            upcomingClassSection
            averageMarkSection
            Spacer()
        }
        .onAppear {
            loadUpcomingClass()
            academicYear = userVM.academicYear
        }
        .sheet(isPresented: $showPreferencesView, onDismiss: {
            academicYear = userVM.academicYear
            print("debug")
        }) {
            NavigationStack {
                PreferencesView(checkWelcomeView: $checkWelcomeView)
            }
        }
        .scrollIndicators(.hidden)
        .safeAreaPadding(.bottom, 100)
        .ignoresSafeArea()
    }
}

// MARK: VARIABLES
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
            
            Text("Hi, \(userVM.name) 🚀")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Spacer()
        }
    }
    
    private var universityInfo: some View {
        Group {
            Text(userVM.university)
            Text(userVM.degree)
        }
        .font(.callout)
        .foregroundStyle(.secondary)
        .lineLimit(1)
    }
    
    private var userInfo: some View {
        HStack() {
            if let profileImage = userVM.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(.trailing)
            } else {
                Image("no-profile-picture")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(.trailing)
            }
            
            VStack(alignment: .leading) {
                Text("\(userVM.name) \(userVM.surname)")
                Text("Student, \(academicYear) year")
                Text(userVM.index)
            }
            .foregroundStyle(.secondary)
            .font(.callout)
            
            
            Spacer()
        }
    }
    
    private var averageMarkSection : some View {
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
                    Text("Average Percentage Score")
                        .foregroundStyle(.secondary)
                        .padding(.top)
                    
                    Spacer()
                    
                    let average = MarksViewModel.averageMarks(marks: marks)
                    HStack {
                        Image(systemName: "graduationcap.circle")
                        Text("\(String(format: "%.2f", average))%")
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
    
    private var upcomingClassSection: some View {
        Group {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "calendar.circle")
                    Text("Upcoming class")
                    Spacer()
                }
                .padding()
                .font(.title)
                if let subject = upcomingSubject {
                    SubjectView(subject: subject, lineLimit: 1, defaultColor: true)
                        .padding(.horizontal, 40)
                        .onTapGesture {
                            activeTab = .plan
                        }
                } else {
                    Text("No upcoming classes")
                        .padding(.horizontal, 40)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: FUNCTIONS
extension HomeView {
    func newsView(text: String) -> some View {
        HStack {
            Image(systemName: "circle.fill")
                .font(.caption)
            
            Text(text)
            
            Spacer()
        }
    }
    
    private func loadUpcomingClass() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            upcomingSubject = planVM.getSubjectClosestToNow(context: context)
        }
    }
}

#Preview {
    GeometryReader { geo in
        HomeView(activeTab: .constant(TabModel.home), checkWelcomeView: .constant(true), safeAreaInsets: geo.safeAreaInsets)
            .environment(DeveloperPreview.shared.userVM)
            .environment(DeveloperPreview.shared.planVM)
    }
}
