//
//  ColorPickerView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 04/12/2024.
//

import SwiftUI
import SwiftData

struct ColorPickerView: View {
    @Environment(\.modelContext) private var context
    @Query private var subjects: [Subject]
    
    @State private var vm = ColorPickerViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient.customGradient
                .ignoresSafeArea()
            
            VStack {
                if (subjects.isEmpty) {
                    NoClassesView()
                } else {
                    List(vm.uniqueSubjects(from: subjects)) { subject in
                        ColorPicker(subject.name, selection: Binding(
                            get: {
                                vm.selectedColors[subject.id] ?? Color.theme.background
                            },
                            set: { newColor in
                                vm.updateSubjectColor(subject, to: newColor, subjects: subjects, context: context)
                            }
                        ))
                        .listRowBackground(Color.theme.background.opacity(0.2))
                    }
                    .scrollContentBackground(.hidden)
                    
                    Spacer()
                    
                    resetButton
                }
            }
            .navigationTitle("Select Colors for Classes")
            .onAppear {
                vm.initializeColors(from: subjects)
            }
        }
    }
}

extension ColorPickerView {
    
    
    private var resetButton: some View {
        Button {
            vm.resetColors(context: context, for: subjects)
        } label: {
            Text("Reset Colors")
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
}

#Preview {
    NavigationStack {
        ColorPickerView()
    }
}
