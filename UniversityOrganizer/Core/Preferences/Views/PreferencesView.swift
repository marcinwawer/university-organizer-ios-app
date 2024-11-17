//
//  PreferencesView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 04/11/2024.
//

import SwiftUI

struct PreferencesView: View {
    @Environment(\.dismiss) var dismiss
    
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
        PreferencesView()
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
}
