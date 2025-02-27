//
//  UserViewModel.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 21/11/2024.
//

import SwiftUI
import SwiftData
import Observation

@Observable
class UserViewModel {
    var profileImage: UIImage?
    
    private let user = User.shared
    private let fileManager = LocalFileManager.shared
    private let folderName = "user_profile_picture"
    private let imageName = "profile_picture"
    
    init() { loadProfilePicture() }
    
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
    
    func loadProfilePicture() {
        profileImage = fileManager.getImage(imageName: imageName, folderName: folderName)
    }
    
    func saveProfilePicture(from data: Data) -> Bool {
        guard let image = UIImage(data: data) else {
            print("Failed to create image from data.")
            return false
        }
        
        if fileManager.saveImage(image: image, imageName: imageName, folderName: folderName) {
            DispatchQueue.main.async {
                self.profileImage = image
            }
            return true
        }
        
        return false
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
        fileManager.deleteImage(imageName: imageName, folderName: folderName)
        loadProfilePicture()
    }
    
    func handleSecurityScopedFile(fileURL: URL, context: ModelContext) -> Bool {
        if fileURL.startAccessingSecurityScopedResource() {
            defer { fileURL.stopAccessingSecurityScopedResource() }
            parseICSFile(fileURL, context: context)
            return true
        } else {
            print("Nie można uzyskać dostępu do pliku.")
            return false
        }
    }
    
    func clearSwiftData(context: ModelContext) {
        do {
            try context.delete(model: Subject.self)
            try context.delete(model: Todo.self)
            try context.delete(model: Note.self)
            try context.delete(model: Mark.self)
        } catch {
            print("failed to clear all subject data from swiftdata")
        }
    }
}
