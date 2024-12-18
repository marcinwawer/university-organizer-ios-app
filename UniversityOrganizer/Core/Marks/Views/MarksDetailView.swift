//
//  MarksDetailView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 17/12/2024.
//

import SwiftUI
import SwiftData

struct MarksDetailView: View {
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Mark.date) private var marks: [Mark]
    
    @State var vm: MarksViewModel
    @State private var showAddMarkSheet = false
    @State private var subjectMarks: [Mark] = []
    
    let subject: Subject
    
    var body: some View {
        VStack() {
            HStack {
                if !subjectMarks.isEmpty { EditButton() }
                Spacer()
                addMarkButton
            }
            .padding([.horizontal, .top])
            .padding(.bottom, 4)
            
            if !subjectMarks.isEmpty {
                subjectMarksList
            } else {
                Spacer()
                EmptyMarksView()
                Spacer()
            }
        }
        .navigationTitle(subject.name)
        .onAppear { updateSubjectMarks() }
        .sheet(isPresented: $showAddMarkSheet, onDismiss: {
            vm.marks = marks
            updateSubjectMarks()
        }, content: {
            NavigationStack {
                AddMarkView(subject: subject, vm: vm)
            }
        })
        .safeAreaPadding(.bottom, 50)
    }
}

#Preview {
    NavigationStack {
        MarksDetailView(vm: DeveloperPreview.shared.marksVM, subject: DeveloperPreview.shared.subject)
    }
}

// MARK: COMPONENTS
extension MarksDetailView {
    private var subjectMarksList: some View {
        List {
            ForEach(subjectMarks) { mark in
                HStack {
                    Text("\(vm.formatPoints(mark.pointsGot))/\(vm.formatPoints(mark.pointsMax)) - \(vm.formatPoints(mark.percentage))%")
                    Spacer()
                    Text("\(vm.formatDate(mark.date))")
                }
            }
            .onDelete { indexSet in
                vm.deleteMark(at: indexSet, context: context)
                vm.marks = marks
                updateSubjectMarks()
            }
        }
    }
    
    private var addMarkButton: some View {
        Button {
            showAddMarkSheet = true
        } label: {
            HStack {
                Image(systemName: "plus.circle")
                
                Text("New Mark")
            }
        }
    }
}

// MARK: FUNCTIONS
extension MarksDetailView {
    private func updateSubjectMarks() {
        subjectMarks = vm.getMarksForSubject(subject: subject)
    }
}
