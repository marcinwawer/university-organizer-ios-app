//
//  AddMarkView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 18/12/2024.
//

import SwiftUI
import SwiftData

struct AddMarkView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    let subject: Subject
    
    @State var vm: MarksViewModel
    @State private var strPointsGot = ""
    @State private var strPointsMax = ""
    @State private var pointsGot: Double = 0
    @State private var pointsMax: Double = 0
    @State private var showAlertPointsGot = false
    @State private var showAlertPointsMax = false
    @State private var showAlertInvalidMark = false
    @State private var invalidMarkAlertText = ""
    
    var body: some View {
        ZStack {
            LinearGradient.customGradient
                .ignoresSafeArea()
            
            VStack {
                pointsGotTextField
                pointsMaxTextField
                
                Spacer()
                
                HStack {
                    Text("Percentage:")
                    Spacer()
                    Text(pointsMax != 0 ? "\(vm.formatPoints(pointsGot / pointsMax * 100))%" : "0%")
                }
                .padding()
                
                saveButton
            }
            
        }
        .navigationTitle("Add Mark ➗")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                XMarkButton()
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
        .alert("You did not provide number of points you got!", isPresented: $showAlertPointsGot) {
            Button("OK", role: .cancel) { }
        }
        .alert("You did not provide maximal number of points available!", isPresented: $showAlertPointsMax) {
            Button("OK", role: .cancel) { }
        }
        .alert(invalidMarkAlertText, isPresented: $showAlertInvalidMark) {
            Button("OK", role: .cancel) { }
        }
    }
}

#Preview {
    NavigationStack {
        AddMarkView(subject: DeveloperPreview.shared.subject, vm: DeveloperPreview.shared.marksVM)
    }
}

// MARK: COMPONENTS
extension AddMarkView {
    private var pointsGotTextField: some View {
        TextField(strPointsGot.isEmpty ? "Number of points you got..." : strPointsGot, text: $strPointsGot)
            .padding()
            .padding(.trailing, 20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .autocorrectionDisabled()
            .overlay(alignment: .trailing) {
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .opacity(strPointsGot.isEmpty ? 0 : 1)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        strPointsGot = ""
                    }
            }
            .padding(.horizontal)
            .keyboardType(.decimalPad)
            .onChange(of: strPointsGot) { _, newValue in
                pointsGot = vm.getDoubleValue(newValue)
            }
    }
    
    private var pointsMaxTextField: some View {
        TextField(strPointsMax.isEmpty ? "Max number of points available..." : strPointsMax, text: $strPointsMax)
            .padding()
            .padding(.trailing, 20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .autocorrectionDisabled()
            .overlay(alignment: .trailing) {
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .opacity(strPointsMax.isEmpty ? 0 : 1)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        strPointsMax = ""
                    }
            }
            .padding(.horizontal)
            .keyboardType(.decimalPad)
            .onChange(of: strPointsMax) { _, newValue in
                pointsMax = vm.getDoubleValue(newValue)
            }
    }
    
    private var saveButton: some View {
        Button {
            guard !strPointsGot.isEmpty else {
                showAlertPointsGot = true
                return
            }
            
            guard !strPointsMax.isEmpty else {
                showAlertPointsMax = true
                return
            }
            
            let (markValid, communicate) = vm.isMarkValid(pointsGot: pointsGot, pointsMax: pointsMax)
            guard markValid else {
                if let com = communicate {
                    invalidMarkAlertText = com
                }
                showAlertInvalidMark = true
                return
            }
            
            vm.addMark(context: context, subject: subject, pointsGot: pointsGot, pointsMax: pointsMax)
            
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
