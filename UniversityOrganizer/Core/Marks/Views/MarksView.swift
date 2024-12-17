//
//  MarksView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 17/12/2024.
//

import SwiftUI
import SwiftData

struct MarksView: View {
    @Environment(PlanViewModel.self) private var planVM
    
//    @Query(sort: \Subject.name) private var subjects: [Subject]
    private var subjects = DeveloperPreview.shared.subjects
    
    var body: some View {
        VStack {
            title
                .padding(.vertical)
                .background(GradientBackground())
            
            List(planVM.uniqueSubjects(from: subjects)) { subject in
                Text(subject.name)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            
            Spacer()
        }
    }
}

#Preview {
    MarksView()
        .environment(DeveloperPreview.shared.planVM)
}

extension MarksView {
    private var title: some View {
        HStack {
            Image(systemName: "graduationcap")
                .font(.title)
            
            Text("Marks")
                .font(.largeTitle)
            
            Spacer()
        }
        .fontWeight(.semibold)
        .padding(.leading)
    }
}
