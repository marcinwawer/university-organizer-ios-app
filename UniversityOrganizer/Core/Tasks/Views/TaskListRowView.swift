//
//  TaskListRowView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 07/12/2024.
//

import SwiftUI

struct TaskListRowView: View {
    let task: Todo
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: task.isDone ? "checkmark.circle" : "circle")
                    .foregroundStyle(task.isDone ? .green : .red)
                
                Text(task.subject.name)
                    .font(.headline)
                    .strikethrough(task.isDone)
                
                Spacer()
            }
            
            Text(task.title)
                .offset(x: 30)
                .padding(.bottom, 4)
                .strikethrough(task.isDone)
            
            if let date = task.dueDate {
                Text(date, style: .date)
                    .offset(x: 30)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(task.subject.getColor()?.opacity(0.8) ?? Color.theme.background)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .customShadow()
    }
}

#Preview {
    TaskListRowView(task: DeveloperPreview.shared.deadline)
}
