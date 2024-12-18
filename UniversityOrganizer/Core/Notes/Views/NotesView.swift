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
    
    @Query private var notes: [Note]
    @Query private var subjects: [Subject]
    
    @State private var vm: NotesViewModel
    
    @State private var selectedNote: Note? = nil
    @State private var showDetailSheet = false
    @State private var showAddNoteView = false
    @State private var showAlert = false
    
    init() {
        _vm = State(wrappedValue: NotesViewModel(notes: []))
    }
    
    var body: some View {
        VStack() {
            title
                .padding(.vertical)
                .padding(.bottom, 8)
                .background(GradientBackground())
            
            HStack {
                Spacer()
                addNoteButton
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            
            ZStack {
                if vm.notes.isEmpty {
                    VStack {
                        EmptyNotesView()
                    }
                    .padding(.top, 150)
                    .transition(.opacity)
                } else {
                    classNotesSection
                }
            }
            .animation(.default, value: vm.notes)
            
            Spacer()
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            vm.notes = notes
        }
        .sheet(isPresented: $showDetailSheet) {
            vm.notes = notes
        } content: {
            if let selectedNote = selectedNote {
                NavigationStack {
                    DetailNoteView(note: selectedNote, vm: vm)
                        .presentationDetents([.fraction(0.5), .large])
                        .presentationDragIndicator(.visible)
                }
            }
        }
        .sheet(isPresented: $showAddNoteView, onDismiss: {
            vm.notes = notes
        }, content: {
            NavigationStack {
                AddNoteView(vm: vm)
            }
        })
        .alert("You can't add any notes, because there are no subjects.", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
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
                                        .transition(.opacity)
                                }
                                .animation(.easeInOut, value: vm.notes)
                            }
                        }
                        .padding(.horizontal)
                        .scrollClipDisabled()
                        .scrollIndicators(.visible)
                    }
                }
                
                Spacer()
                    .frame(height: 100)
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var addNoteButton: some View {
        Button {
            subjects.isEmpty ? (showAlert = true) : (showAddNoteView = true)
        } label: {
            HStack {
                Image(systemName: "plus.circle")
                
                Text("New Note")
            }
        }
    }
}

#Preview {
    NotesView()
        .environment(DeveloperPreview.shared.planVM)
}
