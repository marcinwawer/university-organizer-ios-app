//
//   LocalFileManager.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 04/12/2024.
//

import SwiftUI

class LocalFileManager {
    static let shared = LocalFileManager()
    private init() {}
    
    func saveImage(image: UIImage, imageName: String, folderName: String) -> Bool {
        guard createFolderIfNeeded(folderName: folderName) else {
            return false
        }
        
        guard
            let data = image.pngData(),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
        else {
            return false
        }
        
        do {
            try data.write(to: url)
        } catch let error {
            print("error saving image. image name: \(imageName). error: \(error)")
            return false
        }
        
        return true
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path)
        else {
            return nil
        }
        
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String) -> Bool {
        guard let url = getURLForFolder(folderName: folderName) else {
            return false
        }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                print("error creating directory. folder name: \(folderName). error: \(error)")
                return false
            }
        }
        
        return true
    }
    
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return url.appending(path: folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        
        return folderURL.appending(path: imageName + ".png")
    }
    
    func deleteImage(imageName: String, folderName: String) {
        guard let url = getURLForImage(imageName: imageName, folderName: folderName) else { return }
        
        do {
            try FileManager.default.removeItem(at: url)
            print("Image deleted: \(imageName)")
        } catch {
            print("Error deleting image: \(error)")
        }
    }

}

