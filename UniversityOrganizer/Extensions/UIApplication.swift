//
//  UIApplication.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 20/11/2024.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

