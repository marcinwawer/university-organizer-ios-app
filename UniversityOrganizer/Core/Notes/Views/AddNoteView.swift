//
//  AddNoteView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 16/12/2024.
//

import SwiftUI
import SwiftData

struct AddNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(PlanViewModel.self) private var planVM
    
    @Query private var subjects: [Subject]
    
    @State var vm: NotesViewModel
    @State private var chosenSubjectID: UUID? = nil
    @State private var title = ""
    @State private var content = ""
    
    @State private var showAlertSubject = false
    @State private var showAlertTitle = false
    @State private var showAlertContent = false
    
    var body: some View {
        ZStack {
            LinearGradient.customGradient
                .ignoresSafeArea()
            
            VStack {
                subjectOption
                titleTextField
                    .padding(.bottom)
                contentTextField
                
                Spacer()
                saveButton
            }
        }
        .navigationTitle("Add Note 📒")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                XMarkButton()
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
        .alert("No subject selected!", isPresented: $showAlertSubject) {
            Button("OK", role: .cancel) { }
        }
        .alert("Your note title is empty!", isPresented: $showAlertTitle) {
            Button("OK", role: .cancel) { }
        }
        .alert("Your note content is empty!", isPresented: $showAlertContent) {
            Button("OK", role: .cancel) { }
        }
    }
}

#Preview {
    NavigationStack {
        AddNoteView(vm: DeveloperPreview.shared.notesVM)
            .environment(DeveloperPreview.shared.planVM)
    }
}

extension AddNoteView {
    private var subjectOption: some View {
        HStack(spacing: 0) {
            Text("Class")
            
            Spacer()
            
            Picker("Subject", selection: $chosenSubjectID) {
                ForEach(planVM.uniqueSubjects(from: subjects)) { subject in
                    Text(subject.name).tag(subject.id)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
    }
    
    private var titleTextField: some View {
        TextField(title.isEmpty ? "Enter note title..." : title, text: $title)
            .padding()
            .padding(.trailing, 20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .autocorrectionDisabled()
            .overlay(alignment: .trailing) {
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .opacity(title.isEmpty ? 0 : 1)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        title = ""
                    }
            }
            .padding(.horizontal)
    }
    
    private var contentTextField: some View {
        ZStack(alignment: .topTrailing) {
            TextField(content.isEmpty ? "Note content..." : content, text: $content, axis: .vertical)
                .lineLimit(10)
                .padding()
                .frame(minHeight: 150, alignment: .top)
                .padding(.trailing, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .autocorrectionDisabled()
            
            Image(systemName: "xmark.circle.fill")
                .padding()
                .opacity(content.isEmpty ? 0 : 1)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    content = ""
                }
        }
        .padding(.horizontal)
    }
    
    private var saveButton: some View {
        Button {
            guard let chosenSubjectID = chosenSubjectID else {
                showAlertSubject = true
                return
            }
            
            guard !title.isEmpty else {
                showAlertTitle = true
                return
            }
            
            guard !content.isEmpty else {
                showAlertContent = true
                return
            }
            
            vm.addNote(context: context, title: title, subject: planVM.getSubjectFromId(from: subjects, id: chosenSubjectID), content: content)
            
            dismiss()
        } label: {
            Text("Save")
                .foregroundStyle(.white)
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.theme.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: Color.theme.blue.opacity(0.5), radius: 10)
        }
        .padding(.horizontal)
    }
}
