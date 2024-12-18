//
//  ProfilePicturePickerView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 04/12/2024.
//

import SwiftUI
import PhotosUI

struct ProfilePicturePickerView: View {
    @Environment(UserViewModel.self) private var userVM
    
    @State private var photosPickerItem: PhotosPickerItem?
    @Binding var showPositiveToast: Bool
    @Binding var showNegativeToast: Bool
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $photosPickerItem, matching: .images) {
                HStack {
                    Text("🧏‍♂️ Choose Profile Picture")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(Color.primary)
                .padding()
                .padding(.vertical, 6)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
            }
        }
        .onChange(of: photosPickerItem) { _, _ in
            Task {
                if let photosPickerItem,
                   let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                    
                    if userVM.saveProfilePicture(from: data) { positivePhotoPickerToast() }
                    else { negativePhotoPickerToast() }
                }
                
                photosPickerItem = nil
            }
        }
    }
}

#Preview {
    ProfilePicturePickerView(showPositiveToast: .constant(false), showNegativeToast: .constant(false))
        .environment(DeveloperPreview.shared.userVM)
}

// MARK: FUNCTIONS
extension ProfilePicturePickerView {
    private func positivePhotoPickerToast() {
        withAnimation(.easeIn) {
            showPositiveToast = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut) {
                showPositiveToast = false
            }
        }
    }
    
    private func negativePhotoPickerToast() {
        withAnimation(.easeIn) {
            showNegativeToast = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut) {
                showNegativeToast = false
            }
        }
    }
}
