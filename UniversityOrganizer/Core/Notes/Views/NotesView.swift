//
//  NotesView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 09/12/2024.
//

import SwiftUI
import SwiftData

struct NotesView: View {
//    @Query private var notes: [Note]
//    @Query private var subjects: [Subject]
    private var notes = DeveloperPreview.shared.notes
    private var subjects = DeveloperPreview.shared.subjects
    @State private var vm: NotesViewModel
    
    @Environment(PlanViewModel.self) private var planVM
    
    init() {
        _vm = State(wrappedValue: NotesViewModel(notes: []))
    }
    
    var body: some View {
        VStack() {
            title
                .padding(.vertical)
                .background(GradientBackground())
            
            classNotesSection
            
            Spacer()
        }
        .safeAreaPadding(.bottom, 50)
        .onAppear {
            vm.notes = notes
        }
    }
}

extension NotesView {
    private var title: some View {
        HStack {
            Image(systemName: "note.text")
                .font(.title)
            
            Text("Notes")
                .font(.largeTitle)
            
            Spacer()
        }
        .fontWeight(.semibold)
        .padding(.leading)
    }
    
    private var classNotesSection: some View {
        ScrollView() {
            VStack(alignment: .leading) {
                ForEach(planVM.uniqueSubjects(from: subjects)) { subject in
                    let notesForSubject = vm.getNotesForSubject(subject: subject)
                    
                    if !notesForSubject.isEmpty {
                        Text(subject.name)
                            .font(.title)
                            .padding([.horizontal, .top])
                        
                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(notesForSubject) { note in
                                    SingleNoteView(note: note)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .scrollClipDisabled()
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    NotesView()
        .environment(DeveloperPreview.shared.planVM)
}
