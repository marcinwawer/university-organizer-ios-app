//
//  TasksViewModel.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 07/12/2024.
//

import Foundation
import SwiftData

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
    
    func addTask(context: ModelContext, title: String, subject: Subject?, dueDate: Date? = nil) {
        guard let subject = subject else {
            return
        }
        
        let task = Todo(title: title, subject: subject, dueDate: dueDate)
        context.insert(task)
        
        do {
            try context.save()
        } catch {
            print("error saving task: \(error)")
        }
    }
    
    func deleteTask(from list: inout [Todo], at offsets: IndexSet, context: ModelContext) {
        for index in offsets {
            let task = list[index]
            context.delete(task)
            list.remove(at: index)
        }
        try? context.save()
    }
}
