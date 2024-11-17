//
//  AcademicYear.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 17/11/2024.
//

import Foundation

enum AcademicYear: String, CaseIterable, Identifiable {
    var id: Self { self }
    case first, second, third, fourth, fifth
}
