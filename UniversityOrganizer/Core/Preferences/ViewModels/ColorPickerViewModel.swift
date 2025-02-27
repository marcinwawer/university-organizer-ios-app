//
//  ColorPickerViewModel.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 04/12/2024.
//

import SwiftUI
import SwiftData
import Observation

@Observable
class ColorPickerViewModel {
    var selectedColors: [UUID: Color] = [:]
    private var nameToColorMap: [String: Color] = [:]
    
    func initializeColors(from subjects: [Subject]) {
        for subject in subjects {
            if let existingColor = nameToColorMap[subject.name] {
                selectedColors[subject.id] = existingColor
            } else {
                let newColor = subject.getColor() ?? Color.theme.background
                nameToColorMap[subject.name] = newColor
                selectedColors[subject.id] = newColor
            }
        }
    }
    
    func updateSubjectColor(_ subject: Subject, to color: Color, subjects: [Subject], context: ModelContext) {
        nameToColorMap[subject.name] = color
        
        for subj in subjects where subj.name == subject.name {
            subj.setColor(color)
            selectedColors[subj.id] = color
        }
        
        saveChanges(context: context)
    }
    
    func resetColors(context: ModelContext, for subjects: [Subject]) {
        for subject in subjects {
            subject.colorHex = nil
            selectedColors[subject.id] = nil
            nameToColorMap[subject.name] = nil
            saveChanges(context: context)
        }
    }
    
    private func saveChanges(context: ModelContext) {
        do { try context.save() }
        catch { print("Failed to save changes: \(error)") }
    }
}
