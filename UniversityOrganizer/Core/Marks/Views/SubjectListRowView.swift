//
//  SubjectListRowView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 17/12/2024.
//

import SwiftUI

struct SubjectListRowView: View {
    let subject: Subject
    
    var body: some View {
        HStack {
            Text(subject.name)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .background(subject.getColor()?.opacity(0.8) ?? Color.theme.background)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .customShadow()
    }
}

#Preview {
    SubjectListRowView(subject: DeveloperPreview.shared.subject)
}
