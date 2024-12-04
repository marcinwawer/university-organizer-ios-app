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
        
        for subject in subjects {
            print(subject.name)
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
    
    func getTodayDayAsInt() -> Int {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return (weekday == 1) ? 6 : weekday - 2
    }
    
    func getSubjectClosestToNow(context: ModelContext) -> Subject? {
        let today = getTodayDayAsInt()
        fetchSubjectsForDay(today, context: context)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let currentTime = Date()
        
        return subjects.min { subject1, subject2 in
            let currentSchedules1 = subject1.schedules.compactMap { schedule -> Date? in
                let startTime = formatter.date(from: schedule.startTime)
                let endTime = formatter.date(from: schedule.endTime)
                if let startTime = startTime, let endTime = endTime {
                    if currentTime >= startTime && currentTime <= endTime {
                        return startTime
                    } else if currentTime < startTime {
                        return startTime
                    }
                }
                return nil
            }.min()
            
            let currentSchedules2 = subject2.schedules.compactMap { schedule -> Date? in
                let startTime = formatter.date(from: schedule.startTime)
                let endTime = formatter.date(from: schedule.endTime)
                if let startTime = startTime, let endTime = endTime {
                    if currentTime >= startTime && currentTime <= endTime {
                        return startTime
                    } else if currentTime < startTime {
                        return startTime
                    }
                }
                return nil
            }.min()
            
            return currentSchedules1 ?? Date.distantFuture < currentSchedules2 ?? Date.distantFuture
        }
    }
}
