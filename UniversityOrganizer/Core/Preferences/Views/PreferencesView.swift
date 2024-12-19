//
//  PreferencesView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 04/11/2024.
//

import SwiftUI

struct PreferencesView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(UserViewModel.self) private var vm
    
    @AppStorage("showWelcomeView") private var showWelcomeView = true
    @AppStorage("appearance") private var appearance: Appearance = .light
    
    @Binding var checkWelcomeView: Bool
    
    @State private var showColors = false
    @State private var showProfilePictures = false
    @State private var academicYear = AcademicYear.first
    
    @State private var isInteractionDisabled = false
    @State private var showResetToast = false
    @State private var showPositivePhotoToast = false
    @State private var showNegativePhotoToast = false
    
    var body: some View {
        ZStack {
            LinearGradient.customGradient.ignoresSafeArea()
            
            VStack {
                darkModeOption
                academicYearOption
                colorsOption
                ProfilePicturePickerView(showPositiveToast: $showPositivePhotoToast, showNegativeToast: $showNegativePhotoToast)
                Spacer()
                resetButton
            }
        }
        .allowsHitTesting(!isInteractionDisabled)
        .onAppear { academicYear = vm.academicYear }
        .onChange(of: academicYear) { _, newValue in
            vm.academicYear = newValue
        }
        .navigationTitle("Preferences")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                XMarkButton()
                    .onTapGesture { dismiss() }
            }
        }
        .overlay { toasts }
    }
}

// MARK: VARIABLES
extension PreferencesView {
    private var darkModeOption: some View {
        Toggle("🌙 Dark Mode", isOn: Binding(
            get: { appearance == .dark },
            set: { appearance = $0 ? .dark : .light }
            ))
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
            ColorPickerView()
        }
    }
    
    private var resetButton: some View {
        Button {
            isInteractionDisabled = true
            vm.resetUserData()
            vm.clearSwiftData(context: context)
            
            withAnimation(.easeIn) {
                showResetToast = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeOut) {
                    showResetToast = false
                }
                
                isInteractionDisabled = false
                showWelcomeView = true
                checkWelcomeView = true
                dismiss()
            }
        } label: {
            Text("Reset App Data")
                .foregroundStyle(.white)
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.theme.red)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: Color.theme.red.opacity(0.5), radius: 10)
        }
        .padding(.horizontal)
    }
    
    private var toasts: some View {
        Group {
            if showResetToast {
                Toast(info: "App data reseted!", isPositive: true)
            }
            
            if showPositivePhotoToast {
                Toast(info: "Successfully changed profile picture!", isPositive: true)
            }
            
            if showNegativePhotoToast {
                Toast(info: "Error during changing profile picture.", isPositive: false)
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
