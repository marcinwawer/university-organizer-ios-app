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
        
        let currentTime = getCurrentTimeString()
        
        return subjects.min { subject1, subject2 in
            let currentSchedules1 = findEarliestStartTime(for: subject1.schedules, currentTime: currentTime) ?? "23:59"
            let currentSchedules2 = findEarliestStartTime(for: subject2.schedules, currentTime: currentTime) ?? "23:59"
            
            return currentSchedules1 < currentSchedules2
        }
    }
    
    private func findEarliestStartTime(for schedules: [Schedule], currentTime: String) -> String? {
        return schedules.compactMap { schedule -> String? in
            let startTime = schedule.startTime
            let endTime = schedule.endTime
            if currentTime >= startTime && currentTime <= endTime {
                return startTime
            } else if currentTime < startTime {
                return startTime
            }
            return nil
        }.min()
    }
    
    private func getCurrentTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
}
