//
//  TasksView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 07/12/2024.
//

import SwiftUI
import SwiftData

struct TasksView: View {
    @Query private var tasks: [Todo]
    @State private var vm: TasksViewModel
    
    @State private var chosenType = 0
    @State private var showAddTaskView = false
    
    init() {
        _vm = State(wrappedValue: TasksViewModel(tasks: []))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                title
                taskTypePicker
            }
            .padding(.vertical)
            .background(GradientBackground())
            
            ZStack {
                if chosenType == 0 {
                    List(vm.todos) { todo in
                        TaskListRowView(task: todo)
                            .onTapGesture {
                                withAnimation(.linear) {
                                    vm.markAsDone(todo)
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                    vm.tasks = tasks
                                })
                            }
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .animation(.easeOut, value: vm.todos)
                } else if chosenType == 1 {
                    List(vm.deadlines) { deadline in
                        TaskListRowView(task: deadline)
                            .onTapGesture {
                                withAnimation(.linear) {
                                    vm.markAsDone(deadline)
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                    vm.tasks = tasks
                                })
                            }
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .animation(.easeOut, value: vm.todos)
                } else if chosenType == 2 {
                    List(vm.done) { task in
                        TaskListRowView(task: task)
                            .onTapGesture {
                                withAnimation(.linear) {
                                    vm.markAsUndone(task)
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                    vm.tasks = tasks
                                })
                            }
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .animation(.easeOut, value: vm.todos)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: chosenType)
          
            Spacer()
            
            addTaskButton
        }
        .onAppear {
            vm.tasks = tasks
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
