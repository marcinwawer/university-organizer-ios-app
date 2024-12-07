//
//  TasksViewModel.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 07/12/2024.
//

import Foundation

@Observable class TasksViewModel {
    var todos: [Todo] = []
    var deadlines: [Todo] = []
    var done: [Todo] = []
    
    var tasks: [Todo] = [] {
        didSet {
            todos = todosFromTasks(from: tasks)
            deadlines = deadlinesFromTasks(from: tasks)
            done = doneFromTasks(from: tasks)
        }
    }
    
    init(tasks: [Todo]) {
        self.tasks = tasks
        self.todos = todosFromTasks(from: tasks)
        self.deadlines = deadlinesFromTasks(from: tasks)
    }
    
    func deadlinesFromTasks(from tasks: [Todo]) -> [Todo] {
        return tasks.filter { $0.dueDate != nil && !$0.isDone}
    }
    
    func todosFromTasks(from tasks: [Todo]) -> [Todo] {
        return tasks.filter { $0.dueDate == nil && !$0.isDone}
    }
    
    func doneFromTasks(from tasks: [Todo]) -> [Todo] {
        return tasks.filter { $0.isDone }
    }
    
    func markAsDone(_ task: Todo) {
        task.isDone = true
    }
    
    func markAsUndone(_ task: Todo) {
        task.isDone = false
    }
}
