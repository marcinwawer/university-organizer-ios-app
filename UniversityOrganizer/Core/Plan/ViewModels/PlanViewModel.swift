//
//  PlanViewModel.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 26/11/2024.
//

import Foundation
import SwiftData

@Observable class PlanViewModel {
    var subjects: [Subject] = []
    
    func fetchSubjectsForDay(_ day: Int, context: ModelContext) {
        do {
            let descriptor = FetchDescriptor<Subject>(
                predicate: #Predicate { subject in
                    subject.schedules.contains { $0.dayOfTheWeek == day }
                }
            )
            let fetchedSubjects = try context.fetch(descriptor)
            
            self.subjects = sortSubjectsByEarliestStartTime(fetchedSubjects)
        } catch {
            print("error fetching data: \(error)")
        }
    }
    
    private func sortSubjectsByEarliestStartTime(_ subjects: [Subject]) -> [Subject] {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return subjects.sorted { subject1, subject2 in
            let earliestStartTime1 = subject1.schedules.compactMap { schedule in
                formatter.date(from: schedule.startTime)
            }.min()
            
            let earliestStartTime2 = subject2.schedules.compactMap { schedule in
                formatter.date(from: schedule.startTime)
            }.min()
            
            return earliestStartTime1 ?? Date.distantFuture < earliestStartTime2 ?? Date.distantFuture
        }
    }
}
