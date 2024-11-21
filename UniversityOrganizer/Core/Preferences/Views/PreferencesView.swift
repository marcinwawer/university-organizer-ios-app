//
//  PreferencesView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 04/11/2024.
//

import SwiftUI

struct PreferencesView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Environment(UserViewModel.self) private var vm
    
    @AppStorage("showWelcomeView") private var showWelcomeView = true
    @Binding var checkWelcomeView: Bool
    
    @State private var showColors = false
    @State private var showProfilePictures = false
    @State private var academicYear = AcademicYear.first
    
    var body: some View {
        ZStack {
            LinearGradient.customGradient
                .ignoresSafeArea()
            
            VStack {
                darkModeOption
                academicYearOption
                colorsOption
                profilePictrueOption
                Spacer()
                resetButton
            }
        }
        .navigationTitle("Preferences")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                XMarkButton()
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PreferencesView(checkWelcomeView: .constant(true))
            .environment(DeveloperPreview.shared.userVM)
    }
}

extension PreferencesView {
    private var darkModeOption: some View {
        Toggle("🌙 Dark Mode", isOn: .constant(false))
            .padding()
            .padding(.vertical, 2)
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
    
    private var colorsOption: some View {
        HStack {
            Text("🌈 Set Colors for Classes")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .padding(.vertical, 6)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
        .onTapGesture {
            showColors = true
        }
        .navigationDestination(isPresented: $showColors) {
            EmptyView()
        } //TODO: VM
    }
    
    private var profilePictrueOption: some View {
        HStack {
            Text("🧏‍♂️ Choose Profile Picture")
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
    
    private var resetButton: some View {
        Button {
            vm.resetUserData()
            showWelcomeView = true
            checkWelcomeView = true
            dismiss()
        } label: {
            Text("Reset App Data")
                .foregroundStyle(.white)
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.theme.red)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: Color.theme.blue.opacity(0.5), radius: 10)
        }
        .padding(.horizontal)
    }
}
