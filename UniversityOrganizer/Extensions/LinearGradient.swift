//
//  LinearGradient.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 03/11/2024.
//

import SwiftUI

extension LinearGradient {
    static var customGradient: LinearGradient {
        return LinearGradient(
            colors: [Color(hex: "#5FBEF1"), Color(hex: "#2214EF")],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
