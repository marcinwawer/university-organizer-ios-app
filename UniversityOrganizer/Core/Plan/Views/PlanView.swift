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
    @Environment(PlanViewModel.self) private var vm
    
    @State private var chosenDay = 0
    @State private var opacityAnimation = 0.0
    
    private var opacityAnimationDuration = 0.2
    
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
                        SubjectView(subject: subject, lineLimit: 2, defaultColor: false)
                            .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                        .frame(height: 100)
                }
            }
            .opacity(opacityAnimation)
            .onAppear(perform: onAppearFunc)
            .onDisappear {
                opacityAnimation = 0
            } 
            .onChange(of: chosenDay) { _, newValue in
                onChangeFunc(newValue: newValue)
            }
            .scrollIndicators(.hidden)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    PlanView()
        .environment(DeveloperPreview.shared.planVM)
}

// MARK: COMPONENTS

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

// MARK: FUNCTIONS

extension PlanView {
    private func onChangeFunc(newValue: Int) {
        withAnimation(.easeOut(duration: opacityAnimationDuration)) {
            opacityAnimation = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + opacityAnimationDuration) {
            vm.fetchSubjectsForDay(newValue, context: context)
            withAnimation(.easeIn(duration: opacityAnimationDuration)) {
                opacityAnimation = 1
            }
        }
    }
    
    private func onAppearFunc() {
        chosenDay = vm.shownDay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeIn(duration: opacityAnimationDuration)) {
                opacityAnimation = 1
            }
        }
    }
}
