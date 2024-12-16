//
//  NotesView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 09/12/2024.
//

import SwiftUI
import SwiftData

struct NotesView: View {
    @Environment(PlanViewModel.self) private var planVM
    
//    @Query private var notes: [Note]
//    @Query private var subjects: [Subject]
    private var notes = DeveloperPreview.shared.notes
    private var subjects = DeveloperPreview.shared.subjects
    
    @State private var vm: NotesViewModel
    
    @State private var selectedNote: Note? = nil
    @State private var showDetailSheet = false
    
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
        .onAppear {
            vm.notes = notes
        }
        .sheet(isPresented: $showDetailSheet) {
            vm.notes = notes
        } content: {
            if let selectedNote = selectedNote {
                NavigationStack {
                    DetailNoteView(note: selectedNote)
                        .presentationDetents([.fraction(0.5), .large])
                        .presentationDragIndicator(.visible)
                }
            }
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
                                        .onTapGesture {
                                            selectedNote = note
                                            showDetailSheet = true
                                        }
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
        .safeAreaPadding(.bottom, 100)
    }
}

#Preview {
    NotesView()
        .environment(DeveloperPreview.shared.planVM)
}
