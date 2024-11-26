//
//  PlanView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 26/11/2024.
//

import SwiftUI
import SwiftData

struct PlanView: View {
    @Environment(\.modelContext) private var context
    
    @State private var vm = PlanViewModel()
    
    @State private var chosenDay = 0
    
    var body: some View {
        VStack {
            VStack {
                title
                dayPicker
            }
            .padding(.vertical)
            .background(GradientBackground())
            
            ScrollView {
                if vm.subjects.isEmpty {
                    VStack {
                        EmptySubjectsView()
                    }
                    .padding(.top, 100)
                } else {
                    ForEach(vm.subjects) { subject in
                        SubjectView(subject: subject)
                            .padding(.horizontal, 20)
                    }
                }
            }
            .onAppear {
                vm.fetchSubjectsForDay(0, context: context)
            }
            .onChange(of: chosenDay) { _, newValue in
                vm.fetchSubjectsForDay(newValue, context: context)
            }
            .scrollIndicators(.hidden)
        }
        .safeAreaPadding(.bottom, 100)
    }
}

#Preview {
    PlanView()
}

extension PlanView {
    private var title: some View {
        HStack {
            Image(systemName: "calendar")
                .font(.title)
            
            Text("Plan")
                .font(.largeTitle)
            
            Spacer()
        }
        .fontWeight(.semibold)
        .padding(.leading)
    }
    
    private var dayPicker: some View {
        Picker("Day of the week", selection: $chosenDay) {
            Text("Mon").tag(0)
            Text("Tue").tag(1)
            Text("Wed").tag(2)
            Text("Thu").tag(3)
            Text("Fri").tag(4)
        }
        .pickerStyle(.segmented)
        .padding()
    }
}
