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
                    userVM.saveProfilePicture(from: data)
                }
                
                photosPickerItem = nil
            }
        }
    }
}

#Preview {
    ProfilePicturePickerView()
        .environment(DeveloperPreview.shared.userVM)
}
