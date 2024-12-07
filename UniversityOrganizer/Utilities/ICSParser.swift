//
//  ICSParser.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 20/11/2024.
//

import SwiftUI
import SwiftData

func parseICSFile(_ fileURL: URL, context: ModelContext) {
    do {
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        let events = content.components(separatedBy: "BEGIN:VEVENT")
        
        for event in events {
            if let summary = extractField(from: event, fieldName: "SUMMARY"),
               let dtstart = extractField(from: event, fieldName: "DTSTART;VALUE=DATE-TIME"),
               let dtend = extractField(from: event, fieldName: "DTEND;VALUE=DATE-TIME"),
               let description = extractField(from: event, fieldName: "DESCRIPTION"),
               let startTime = extractTime(from: dtstart),
               let endTime = extractTime(from: dtend),
               let dayOfTheWeek = extractDayOfWeek(from: dtstart) {
                
                let firstChar = summary.first
                guard let subjectType = SubjectType.from(character: firstChar ?? " ") else {
                    continue
                }
                let cleanedSummary = summary.dropFirst(3).trimmingCharacters(in: .whitespacesAndNewlines)
                let room = extractRoom(from: description)
                let building = extractBuilding(from: description)
                
                var subject: Subject? = try? context.fetch(
                    FetchDescriptor(
                        predicate: #Predicate { subject in
                            subject.name == cleanedSummary &&
                            subject.type == subjectType.rawValue
                        }
                    )
                ).first
                
                if subject == nil {
                    subject = Subject(name: cleanedSummary, type: subjectType, room: room, building: building)
                    if let subject {
                        context.insert(subject)
                    }
                }
                
                if let subject = subject {
                    if !subject.schedules.contains(where: { $0.startTime == startTime && $0.endTime == endTime }) {
                        let schedule = Schedule(startTime: startTime, endTime: endTime, dayOfTheWeek: dayOfTheWeek)
                        subject.schedules.append(schedule)
                    }
                }
            }
        }
        
        try context.save()
        print("data saved correctly to swiftdata")
    } catch {
        print("error during parsing ics file: \(error)")
    }
}

func extractRoom(from description: String) -> String? {
    if let roomRange = description.range(of: "Sala: ") {
        let start = description[roomRange.upperBound...]
        if let room = start.components(separatedBy: "\\").first?.trimmingCharacters(in: .whitespacesAndNewlines) {
            return room
        }
    }
    return nil
}

func extractBuilding(from description: String) -> String? {
    if let startRange = description.range(of: "["),
       let endRange = description.range(of: "]", range: startRange.upperBound..<description.endIndex) {
        let building = description[startRange.upperBound..<endRange.lowerBound]
        return String(building).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    return nil
}

func extractField(from text: String, fieldName: String) -> String? {
    guard let range = text.range(of: "\(fieldName):") else { return nil }
    let start = text[range.upperBound...]
    return start.components(separatedBy: "\n").first?.trimmingCharacters(in: .whitespacesAndNewlines)
}

func extractTime(from dateTime: String) -> String? {
    guard dateTime.count >= 13 else { return nil }
    let hour = dateTime[dateTime.index(dateTime.startIndex, offsetBy: 9)..<dateTime.index(dateTime.startIndex, offsetBy: 11)]
    let minute = dateTime[dateTime.index(dateTime.startIndex, offsetBy: 11)..<dateTime.index(dateTime.startIndex, offsetBy: 13)]
    return "\(hour):\(minute)"
}

func extractDayOfWeek(from dateString: String) -> Int? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd'T'HHmmss"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    guard let date = formatter.date(from: dateString) else {
        return nil
    }
    
    var calendar = Calendar.current
    calendar.firstWeekday = 2
    
    let weekdayNumber = calendar.component(.weekday, from: date)
    return (weekdayNumber - calendar.firstWeekday + 7) % 7
}
