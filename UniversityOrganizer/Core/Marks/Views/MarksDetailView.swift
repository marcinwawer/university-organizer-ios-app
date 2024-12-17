//
//  MarksDetailView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 17/12/2024.
//

import SwiftUI

struct MarksDetailView: View {
    let subject: Subject
    var vm: MarksViewModel
    
    var body: some View {
        let subjectMarks = vm.getMarksForSubject(subject: subject)
        
        VStack {
            if !subjectMarks.isEmpty {
                List(subjectMarks) { mark in
                    HStack {
                        Text("\(formatPoints(mark.pointsGot))/\(formatPoints(mark.pointsMax)) - \(formatPoints(mark.percentage))%")
                        Spacer()
                        Text("\(formatDate(mark.date))")
                    }
                }
            } else {
                EmptyMarksView()
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
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
}
