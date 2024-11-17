//
//  WelcomView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 17/11/2024.
//

import SwiftUI

struct WelcomeView: View {
    @State private var name = ""
    @State private var surname = ""
    @State private var index = ""
    @State private var university = ""
    @State private var degree = ""
    @State private var academicYear = AcademicYear.first
    
    @State private var showProfilePictures = false
    
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
                    
                    profilePictrueOption
                }
                .navigationTitle("Set your info! 🤩")
                .toolbarBackground(LinearGradient.customGradient)
                
                Spacer()
                
                uploadPlanButton
                    .padding(.bottom, 4)
                
                saveButton
            }
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}

extension WelcomeView {
    private var nameTextField: some View {
        TextField("Enter your name...", text: $name)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
    }
    
    private var surnameTextField: some View {
        TextField("Enter your surname...", text: $surname)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
    }
    
    private var indexTextField: some View {
        TextField("Enter your university index...", text: $index)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            .keyboardType(.numberPad)
    }
    
    private var universityTextField: some View {
        TextField("Enter your university name...", text: $university)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
    }
    
    private var degreeTextField: some View {
        TextField("Enter your degree name...", text: $degree)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
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
    
    private var profilePictrueOption: some View {
        HStack {
            Text("🧏‍♂️ Choose profile picture")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .padding(.vertical, 6)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
        .onTapGesture {
            showProfilePictures = true
        }
        .navigationDestination(isPresented: $showProfilePictures) {
            EmptyView()
        }
    }
    
    private var uploadPlanButton: some View {
        Button {
            //TODO: parser
        } label: {
            Text("Upload your plan as iCal file")
                .foregroundStyle(.white)
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.theme.green)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: Color.theme.green.opacity(0.7), radius: 10)
        }
        .padding(.horizontal)
    }
    
    private var saveButton: some View {
        Button {
            //TODO: vm
        } label: {
            Text("Save")
                .foregroundStyle(.white)
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.theme.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: Color.theme.blue.opacity(0.7), radius: 10)
        }
        .padding(.horizontal)
    }
}
