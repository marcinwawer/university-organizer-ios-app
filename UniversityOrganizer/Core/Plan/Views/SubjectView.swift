//
//  SubjectView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 26/11/2024.
//

import SwiftUI

struct SubjectView: View {
    var subject: Subject
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.theme.background)
                .customShadow()
            
            VStack(alignment: .leading) {
                Text("\(subject.type) - \(subject.name)") 
                    .font(.title2)
                
                Spacer()
                
                HStack {
                    Image(systemName: "calendar.circle")
                    Text(subject.schedules.first?.dayOfTheWeek.dayOfWeek() ?? "?")
                }
                
                HStack {
                    Image(systemName: "timer.circle")
                    Text("\(subject.schedules.first?.startTime ?? "?") - \(subject.schedules.first?.endTime ?? "?")")
                }
                
                HStack {
                    Image(systemName: "mappin.circle")
                    Text("\(subject.building ?? "?"), \(subject.room ?? "?")")
                }
            }
            .padding()
            .lineLimit(1)
        }
        .frame(height: 140)
    }
}

#Preview {
    SubjectView(subject: DeveloperPreview.shared.subject)
}
