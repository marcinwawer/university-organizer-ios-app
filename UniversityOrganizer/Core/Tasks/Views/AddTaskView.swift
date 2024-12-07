//
//  AddTaskView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 07/12/2024.
//

import SwiftUI
import SwiftData

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(PlanViewModel.self) private var planVM
    
    @Query private var subjects: [Subject]
    
    @State var vm: TasksViewModel
    @State private var title = ""
    @State private var chosenSubjectID: UUID? = nil
    @State private var chosenType = 0
    @State private var deadline = Date()
    @State private var showAlertSubject = false
    @State private var showAlertTitle = false
    
    var body: some View {
        ZStack {
            LinearGradient.customGradient
                .ignoresSafeArea()
            
            VStack {
                subjectOption
                titleTextField
                
                if chosenType == 1 {
                    deadlineOption
                        .transition(.move(edge: .leading))
                }
                
                Spacer()
                
                taskTypePicker
                saveButton
            }
            .animation(.easeInOut, value: chosenType)
        }
        .navigationTitle("Add Task ✏️")
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
        .alert("Your task title is empty!", isPresented: $showAlertTitle) {
            Button("OK", role: .cancel) { }
        }
    }
}

#Preview {
    NavigationStack {
        AddTaskView(vm: DeveloperPreview.shared.tasksVM)
            .environment(DeveloperPreview.shared.planVM)
    }
}

extension AddTaskView {
    private var titleTextField: some View {
        TextField(title.isEmpty ? "Enter task title..." : title, text: $title)
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
    
    private var deadlineOption: some View {
        DatePicker(
            "Deadline",
            selection: $deadline,
            displayedComponents: [.date]
        )
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
    }
    
    private var taskTypePicker: some View {
        Picker("Type of task", selection: $chosenType) {
            Text("To-do").tag(0)
            Text("Deadline").tag(1)
        }
        .pickerStyle(.segmented)
        .padding()
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
            
            if chosenType == 1 {
                vm.addTask(context: context, title: title, subject: planVM.getSubjectFromId(from: subjects, id: chosenSubjectID), dueDate: deadline)
            } else {
                vm.addTask(context: context, title: title, subject: planVM.getSubjectFromId(from: subjects, id: chosenSubjectID))
            }
            
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
