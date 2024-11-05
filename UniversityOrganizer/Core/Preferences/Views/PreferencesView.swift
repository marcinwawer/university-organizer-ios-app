//
//  PreferencesView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 04/11/2024.
//

import SwiftUI

struct PreferencesView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Image(systemName: "slider.horizontal.3")
                .font(.title)
            Spacer()
            
            Text("Preferences") 
                .font(.largeTitle)
                .fontWeight(.semibold)
            Spacer()
        }
    }
}

#Preview {
    PreferencesView()
}
