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
    
    private var startOfDay = "00:00"
    private var endOfDay = "23:59"
    private var dateFormat = "HH:mm"
    
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
    
    func getSubjectFromId(from subjects: [Subject], id: UUID) -> Subject? {
        return subjects.first(where: { $0.id == id })
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
        
        #if DEBUG
        for subject in subjects {
            print(subject.name)
        }
        #endif
    }
    
    private func sortSubjectsByEarliestStartTime(_ subjects: [Subject]) -> [Subject] {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        
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
        
        var currentTime = getCurrentTimeString()
        
        if isAllDoneForToday(currentDay: today, currentTime: currentTime) {
            let nextDay = nextAvailableDay(after: today)
            shownDay = nextDay
            currentTime = startOfDay
            fetchSubjectsForDay(nextDay, context: context)
        }
        
        return findClosestSubject(to: currentTime, from: subjects)
    }
    
    private func isAllDoneForToday(currentDay: Int, currentTime: String) -> Bool {
        guard let lastSubject = subjects.last else {
            return true
        }
        
        let lastEndTime = lastSubject.schedules.compactMap { $0.endTime }.max() ?? startOfDay
        return currentTime > lastEndTime
    }
    
    private func nextAvailableDay(after day: Int) -> Int {
        return day >= 6 ? 0 : day + 1
    }
    
    private func findClosestSubject(to currentTime: String, from subjects: [Subject]) -> Subject? {
        return subjects.min { subject1, subject2 in
            let s1Time = findEarliestStartTime(for: subject1.schedules, currentTime: currentTime) ?? endOfDay
            let s2Time = findEarliestStartTime(for: subject2.schedules, currentTime: currentTime) ?? endOfDay
            return s1Time < s2Time
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
        formatter.dateFormat = dateFormat
        return formatter.string(from: Date())
    }
}
