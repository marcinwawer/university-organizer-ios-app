//
//  MarksDetailView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 17/12/2024.
//

import SwiftUI
import SwiftData

struct MarksDetailView: View {
    @Environment(\.modelContext) private var context
    
    let subject: Subject
    var vm: MarksViewModel
    
    var body: some View {
        let subjectMarks = vm.getMarksForSubject(subject: subject)
        
        VStack() {
            HStack {
                if !subjectMarks.isEmpty { EditButton() }
                Spacer()
                // add button
            }
            .padding([.horizontal, .top])
            
            if !subjectMarks.isEmpty {
                List {
                    ForEach(subjectMarks) { mark in
                        HStack {
                            Text("\(formatPoints(mark.pointsGot))/\(formatPoints(mark.pointsMax)) - \(formatPoints(mark.percentage))%")
                            Spacer()
                            Text("\(formatDate(mark.date))")
                        }
                    }
                    .onDelete { indexSet in
                        vm.deleteMark(at: indexSet, context: context)
                    }
                }
            } else {
                Spacer()
                EmptyMarksView()
                Spacer()
            }
        }
        .navigationTitle(subject.name)
    }
}

#Preview {
    NavigationStack {
        MarksDetailView(subject: DeveloperPreview.shared.subject, vm: DeveloperPreview.shared.marksVM)
    }
}

extension MarksDetailView {
    func formatPoints(_ points: Double) -> String {
        return String(points).replacingOccurrences(of: "\\.?0+$", with: "", options: .regularExpression)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
}
