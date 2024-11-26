//
//  User.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 21/11/2024.
//

import SwiftUI

class User {
    static let shared = User()
    
    @AppStorage("name") @ObservationIgnored var name = ""
    @AppStorage("surname") @ObservationIgnored var surname = ""
    @AppStorage("index") @ObservationIgnored var index = ""
    @AppStorage("university") @ObservationIgnored var university = ""
    @AppStorage("degree") @ObservationIgnored var degree = ""
    @AppStorage("academicYear") @ObservationIgnored var academicYear = AcademicYear.first.rawValue
    
    private init() {}
}
