//
//  EmptyTasksView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 07/12/2024.
//

import SwiftUI

struct EmptyTasksView: View {
    let taskType: String
    
    var body: some View {
        Image(systemName: "pencil.slash")
            .resizable()
            .frame(width: 50, height: 50)
            .foregroundStyle(.secondary)
        
        Text("There are no \(taskType)! 🤓")
            .font(.title)
            .fontWeight(.semibold)
    }
}

#Preview {
    EmptyTasksView(taskType: "todos")
}
