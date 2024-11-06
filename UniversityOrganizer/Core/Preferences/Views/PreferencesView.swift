//
//  PreferencesView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 04/11/2024.
//

import SwiftUI

struct PreferencesView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var showColors = false
    @State private var showProfilePictures = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.customGradient
                    .ignoresSafeArea()
                
                VStack {
                    Toggle("🌙 Dark Mode", isOn: .constant(false))
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                    
                    HStack(spacing: 0) {
                        Text("🎓 Academic Year")
                        
                        Spacer()
                        
                        Text("Third") //TODO: vm
                        
                        Picker("Sort by", selection: .constant("")) {
                            Text("First").tag(1)
                            Text("Second").tag(2)
                            Text("Third").tag(3)
                            Text("Fourth").tag(4)
                            Text("Fifth").tag(5)
                        } // TODO: VM
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                    
                    HStack {
                        Text("🌈 Set Colors for Classes")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                    .onTapGesture {
                        showColors = true
                    }
                    .navigationDestination(isPresented: $showColors) {
                        EmptyView()
                    } //TODO: VM
                    
                    HStack {
                        Text("🧏‍♂️ Choose profile picture")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                    .onTapGesture {
                        showColors = true
                    }
                    .navigationDestination(isPresented: $showProfilePictures) {
                        EmptyView()
                    }
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "slider.horizontal.3")
                }
                
                ToolbarItem(placement:.principal) {
                    Text("Preferences")
                        .font(.largeTitle)
                        .fontWeight(.medium)
                }
            }
        }
    }
}

#Preview {
    PreferencesView()
}
