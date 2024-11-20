//
//  ICSParser.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 20/11/2024.
//

import SwiftUI
import Foundation

// Funkcja do odczytu pliku `.ics`
func readICSFile(named fileName: String) {
    if let path = Bundle.main.path(forResource: fileName, ofType: "ics") {
        do {
            let fileContent = try String(contentsOfFile: path, encoding: .utf8)
            parseICSContent(fileContent)
        } catch {
            print("Error while reading the file: \(error)")
        }
    } else {
        print("\(fileName).ics was not found.")
    }
}

func parseICSContent(_ content: String) {
    var scheduleMap: [String: [[String]]] = [:]
    let events = content.components(separatedBy: "BEGIN:VEVENT")
    
    for event in events {
        if let summary = extractField(from: event, fieldName: "SUMMARY"),
           let dtstart = extractField(from: event, fieldName: "DTSTART;VALUE=DATE-TIME"),
           let dtend = extractField(from: event, fieldName: "DTEND;VALUE=DATE-TIME"),
           let startTime = extractTime(from: dtstart),
           let endTime = extractTime(from: dtend) {
            
            let timePair = [startTime, endTime]
            
            if var timesArray = scheduleMap[summary] {
                if !timesArray.contains(timePair) {
                    timesArray.append(timePair)
                    scheduleMap[summary] = timesArray
                }
            } else {
                scheduleMap[summary] = [timePair]
            }
        }
    }
    
    // Wyświetlanie wyników dla każdego przedmiotu
    for (summary, times) in scheduleMap {
        print("Nazwa zajęć: \(summary)")
        for time in times {
            print("Czas rozpoczęcia: \(time[0]), Czas zakończenia: \(time[1])")
        }
        print("---------------")
    }
}

// Funkcja pomocnicza do wyciągania danych z danego pola
func extractField(from text: String, fieldName: String) -> String? {
    guard let range = text.range(of: "\(fieldName):") else { return nil }
    let start = text[range.upperBound...]
    return start.components(separatedBy: "\n").first?.trimmingCharacters(in: .whitespacesAndNewlines)
}

// Funkcja pomocnicza do wyciągania czasu (HH:MM) z pola `DTSTART` lub `DTEND`
func extractTime(from dateTime: String) -> String? {
    guard dateTime.count >= 13 else { return nil }
    let hour = dateTime[dateTime.index(dateTime.startIndex, offsetBy: 9)..<dateTime.index(dateTime.startIndex, offsetBy: 11)]
    let minute = dateTime[dateTime.index(dateTime.startIndex, offsetBy: 11)..<dateTime.index(dateTime.startIndex, offsetBy: 13)]
    return "\(hour):\(minute)"
}



