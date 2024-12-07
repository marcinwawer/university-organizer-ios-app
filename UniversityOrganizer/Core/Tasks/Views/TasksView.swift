//
//  TasksView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 07/12/2024.
//

import SwiftUI

struct TasksView: View {
    @State private var chosenType = 0
    @State private var showAddTaskView = false
    
    var body: some View {
        VStack {
            VStack {
                title
                taskTypePicker
            }
            .padding(.vertical)
            .background(GradientBackground())
            
            Spacer()
            
            addTaskButton
        }
        .safeAreaPadding(.bottom, 70)
        .sheet(isPresented: $showAddTaskView) {
            NavigationStack {
                AddTaskView()
            }
        }
    }
}

#Preview {
    TasksView()
}

extension TasksView {
    private var title: some View {
        HStack {
            Image(systemName: "list.bullet")
                .font(.title)
            
            Text("Tasks")
                .font(.largeTitle)
            
            Spacer()
        }
        .fontWeight(.semibold)
        .padding(.leading)
    }
    
    private var taskTypePicker: some View {
        Picker("Type of task", selection: $chosenType) {
            Text("To-do").tag(0)
            Text("Deadlines").tag(1)
            Text("Done").tag(2)
        }
        .pickerStyle(.segmented)
        .padding()
    }
    
    private var addTaskButton: some View {
        Button {
            showAddTaskView = true
        } label: {
            HStack {
                Image(systemName: "plus.circle")
                
                Text("New Task")
            }
        }
    }
}
