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
    var shownDay = 0
    
    func uniqueSubjects(from subjects: [Subject]) -> [Subject] {
        var seenNames: Set<String> = []
        return subjects.filter { subject in
            if seenNames.contains(subject.name) {
                return false
            } else {
                seenNames.insert(subject.name)
                return true
            }
        }
    }
    
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
    
    func getSubjectClosestToNow(context: ModelContext) -> Subject? {
        let today = getTodayDayAsInt()
        shownDay = today
        fetchSubjectsForDay(today, context: context)
        
        let currentTime = getCurrentTimeString()
        
        if let lastSubject = subjects.last,
           let lastEndTime = lastSubject.schedules.compactMap({ schedule in
               return schedule.endTime
           }).max(), currentTime > lastEndTime {
            
            let nextDay = today == 6 ? 0 : today + 1
            shownDay = nextDay
            fetchSubjectsForDay(nextDay, context: context)
        }
        
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
    
    private func getTodayDayAsInt() -> Int {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return (weekday == 1) ? 6 : weekday - 2
    }
    
    private func getCurrentTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
}
