//
//  EmptySubjectsView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 26/11/2024.
//

import SwiftUI

struct EmptySubjectsView: View {
    var body: some View {
        Image(systemName: "calendar.badge.exclamationmark")
            .resizable()
            .frame(width: 60, height: 50)
            .foregroundStyle(.secondary)
        
        Text("No classes today! 🥳")
            .font(.title)
            .fontWeight(.semibold)
    }
}

#Preview {
    EmptySubjectsView()
}
