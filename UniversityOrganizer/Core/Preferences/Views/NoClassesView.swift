//
//  NoClassesView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 04/12/2024.
//

import SwiftUI

struct NoClassesView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "calendar.badge.exclamationmark")
                .resizable()
                .frame(width: 60, height: 50)
            
            Text("There are no classes 😭")
                .font(.title)
                .fontWeight(.semibold)
            
            Text("You probably did not import any ics file with your plan. Give it a check and return here!")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
        }
        .padding(40)
    }
}

#Preview {
    NoClassesView()
}
