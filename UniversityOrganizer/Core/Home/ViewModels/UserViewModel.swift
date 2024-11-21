//
//  UserViewModel.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 21/11/2024.
//

import SwiftUI

@Observable class UserViewModel {
    private let user = User.shared
    
    var name: String {
        get { user.name }
        set { user.name = newValue }
    }
    
    var surname: String {
        get { user.surname }
        set { user.surname = newValue }
    }
    
    var index: String {
        get { user.index }
        set { user.index = newValue }
    }
    
    var university: String {
        get { user.university }
        set { user.university = newValue }
    }
    
    var degree: String {
        get { user.degree }
        set { user.degree = newValue }
    }
    
    var academicYear: AcademicYear {
        get { AcademicYear(rawValue: user.academicYear) ?? .first }
        set { user.academicYear = newValue.rawValue }
    }
    
    func updateUser(name: String, surname: String, index: String, university: String, degree: String, academicYear: AcademicYear) {
        self.name = name
        self.surname = surname
        self.index = index
        self.university = university
        self.degree = degree
        self.academicYear = academicYear
    }
    
    func resetUserData() {
        name = ""
        surname = ""
        index = ""
        university = ""
        degree = ""
        academicYear = .first
    }
}
