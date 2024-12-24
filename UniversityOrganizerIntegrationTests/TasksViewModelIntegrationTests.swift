//
//  TasksViewModelIntegrationTests.swift
//  UniversityOrganizerIntegrationTests
//
//  Created by Marcin Wawer on 23-12-2024.
//

import XCTest
import SwiftData
@testable import UniversityOrganizer

@MainActor
final class TasksViewModelIntegrationTests: XCTestCase {
    private var container: ModelContainer!
    private var context: ModelContext!
    private var taskVM: TasksViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Todo.self, Subject.self, configurations: config)
        context = container.mainContext
        
        taskVM = TasksViewModel(tasks: [])
    }
    
    override func tearDownWithError() throws {
        container = nil
        context = nil
        taskVM = nil
        
        try super.tearDownWithError()
    }
    
    func testAddTask() throws {
        let subject = Subject(name: "Test Subject", type: .lecture)
        context.insert(subject)
        try context.save()
        
        taskVM.addTask(context: context, title: "New task", subject: subject, dueDate: nil)
        try context.save()
        
        let fetchDescriptor = FetchDescriptor<Todo>()
        let fetchedTodos = try context.fetch(fetchDescriptor)
        
        XCTAssertEqual(fetchedTodos.count, 1, "There should be i task in db")
        XCTAssertEqual(fetchedTodos.first?.title, "New task")
        XCTAssertFalse(fetchedTodos.first?.isDone ?? true, "New task should not be done (isDone = false).")
    }
    
    func testDeleteTask() throws {
        let subject = Subject(name: "Test Subject", type: .lecture)
        let todo = Todo(title: "To delete", subject: subject)
        
        context.insert(subject)
        context.insert(todo)
        try context.save()
        
        taskVM.tasks = [todo]
        var list = taskVM.todos
        
        taskVM.deleteTask(from: &list, at: IndexSet(integer: 0), context: context)
        try context.save()
        
        let fetchDescriptor = FetchDescriptor<Todo>()
        let fetchedTodos = try context.fetch(fetchDescriptor)
        
        XCTAssertTrue(fetchedTodos.isEmpty, "Todo list in db should be empty after deleting.")
    }
    
    func testMarkAsDone() throws {
        let subject = Subject(name: "Test Subject", type: .lecture)
        let todo = Todo(title: "Test", isDone: false, subject: subject, dueDate: nil)
        
        context.insert(subject)
        context.insert(todo)
        try context.save()
        
        taskVM.markAsDone(todo)
        try context.save()
        
        let fetchDescriptor = FetchDescriptor<Todo>()
        let fetchedTodos = try context.fetch(fetchDescriptor)
        XCTAssertTrue(fetchedTodos[0].isDone, "Task should have isDone = true.")
    }
    
    func testMarkAsUndone() throws {
        let subject = Subject(name: "Test Subject", type: .lecture)
        let todo = Todo(title: "Test", isDone: true, subject: subject, dueDate: nil)
        
        context.insert(subject)
        context.insert(todo)
        try context.save()
        
        taskVM.markAsUndone(todo)
        try context.save()
        
        let fetchDescriptor = FetchDescriptor<Todo>()
        let fetchedTodos = try context.fetch(fetchDescriptor)
        XCTAssertFalse(fetchedTodos[0].isDone, "Task should have isDone = false.")
    }
    
    func testTasksClassification() throws {
        let subject = Subject(name: "Test Subject", type: .lecture)
        
        let todo1 = Todo(title: "Normal TODO", isDone: false, subject: subject, dueDate: nil)
        let deadline1 = Todo(title: "Deadline task", isDone: false, subject: subject,
                             dueDate: Date())
        let done1 = Todo(title: "Done task", isDone: true, subject: subject)
        
        context.insert(subject)
        context.insert(todo1)
        context.insert(deadline1)
        context.insert(done1)
        
        try context.save()

        taskVM.tasks = [todo1, deadline1, done1]
        
        XCTAssertEqual(taskVM.todos.count, 1, "There should be one elem in section 'todos'.")
        XCTAssertEqual(taskVM.deadlines.count, 1, "There should be one elem in section 'deadlines'.")
        XCTAssertEqual(taskVM.done.count, 1, "There should be one elem in section 'done'.")
        
        XCTAssertEqual(taskVM.todos.first?.title, "Normal TODO")
        XCTAssertEqual(taskVM.deadlines.first?.title, "Deadline task")
        XCTAssertEqual(taskVM.done.first?.title, "Done task")
    }
}
