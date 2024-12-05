//
//  WelcomView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 17/11/2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct WelcomeView: View {
    @AppStorage("showWelcomeView") private var showWelcomeView = true
    @Binding var checkWelcomeView: Bool
    
    @Environment(UserViewModel.self) private var vm
    @Environment(\.modelContext) private var context
    
    @State private var name = ""
    @State private var surname = ""
    @State private var index = ""
    @State private var university = ""
    @State private var degree = ""
    @State private var academicYear = AcademicYear.first
    @State private var showProfilePictures = false
    @State private var importing = false
    
    var body: some View {
        ZStack {
            LinearGradient.customGradient.ignoresSafeArea()
            
            VStack {
                ScrollView {
                    nameTextField
                        .padding(.top)
                    
                    surnameTextField
                    
                    indexTextField
                    
                    universityTextField
                    
                    degreeTextField
                        .padding(.bottom)
                    
                    academicYearOption
                    
                    ProfilePicturePickerView()
                }
                .navigationTitle("Set your info! 🤩")
                .toolbarBackground(LinearGradient.customGradient)
                
                Spacer()
                
                uploadPlanButton
                    .padding(.bottom, 4)
                
                saveButton
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            name = vm.name
            surname = vm.surname
            index = vm.index
            university = vm.university
            degree = vm.degree
            academicYear = vm.academicYear
        }
        .fileImporter(
            isPresented: $importing,
            allowedContentTypes: {
                if let calendarType = UTType(filenameExtension: "ics") {
                    return [calendarType]
                } else {
                    return []
                }
            }()
        ) { result in
            switch result {
            case .success(let fileURL):
                vm.handleSecurityScopedFile(fileURL: fileURL, context: context)
            case .failure(let error):
                print("error choosing file: \(error.localizedDescription)")
            }
        }
        .sheet(isPresented: $showProfilePictures) {
            EmptyView()
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView(checkWelcomeView: .constant(true))
            .environment(DeveloperPreview.shared.userVM)
    }
}

extension WelcomeView {
    private var nameTextField: some View {
        TextField(name.isEmpty ? "Enter your name..." : name, text: $name)
            .padding()
            .padding(.trailing, 20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .autocorrectionDisabled()
            .overlay(alignment: .trailing) {
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .opacity(name.isEmpty ? 0 : 1)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        name = ""
                    }
            }
            .padding(.horizontal)
    }
    
    private var surnameTextField: some View {
        TextField(surname.isEmpty ? "Enter your surname..." : surname, text: $surname)
            .padding()
            .padding(.trailing, 20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .autocorrectionDisabled()
            .overlay(alignment: .trailing) {
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .opacity(surname.isEmpty ? 0 : 1)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        surname = ""
                    }
            }
            .padding(.horizontal)
    }
    
    private var indexTextField: some View {
        TextField(index.isEmpty ? "Enter your university index..." : index, text: $index)
            .padding()
            .padding(.trailing, 20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .autocorrectionDisabled()
            .overlay(alignment: .trailing) {
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .opacity(index.isEmpty ? 0 : 1)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        index = ""
                    }
            }
            .padding(.horizontal)
            .keyboardType(.numberPad)
    }
    
    private var universityTextField: some View {
        TextField(university.isEmpty ? "Enter your university name..." : university, text: $university)
            .padding()
            .padding(.trailing, 20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .autocorrectionDisabled()
            .overlay(alignment: .trailing) {
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .opacity(university.isEmpty ? 0 : 1)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        university = ""
                    }
            }
            .padding(.horizontal)
    }
    
    private var degreeTextField: some View {
        TextField(degree.isEmpty ? "Enter your degree name..." : degree, text: $degree)
            .padding()
            .padding(.trailing, 20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .autocorrectionDisabled()
            .overlay(alignment: .trailing) {
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .opacity(degree.isEmpty ? 0 : 1)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        degree = ""
                    }
            }
            .padding(.horizontal)
    }
    
    private var academicYearOption: some View {
        HStack(spacing: 0) {
            Text("🎓 Academic Year")
            
            Spacer()
            
            Picker("Academic year", selection: $academicYear) {
                ForEach(AcademicYear.allCases) { academicYear in
                    Text(academicYear.rawValue.capitalized).tag(academicYear)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
    }
    
    private var uploadPlanButton: some View {
        Button {
            importing = true
        } label: {
            Text("Upload your plan as iCal file")
                .foregroundStyle(.white)
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.theme.green)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: Color.theme.green.opacity(0.5), radius: 10)
        }
        .padding(.horizontal)
    }
    
    private var saveButton: some View {
        Button {
            vm.updateUser(
                name: name,
                surname: surname,
                index: index,
                university: university,
                degree: degree,
                academicYear: academicYear
            )
            
            showWelcomeView = false
            checkWelcomeView = false
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
