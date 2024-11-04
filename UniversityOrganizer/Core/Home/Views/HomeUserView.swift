//
//  HomeUserView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 03/11/2024.
//

import SwiftUI

struct HomeUserView: View {
    var body: some View {
        VStack() {
            header
                .padding(.bottom, 4)
            
            universityInfo
            
            userInfo
                .padding(.top)
        }
    }
}

#Preview {
    HomeUserView()
        .padding()
    
    Spacer()
}

extension HomeUserView {
    private var header: some View {
        HStack {
            Image(systemName: "slider.horizontal.3")
                .font(.title)
            Spacer()
            
            Text("Hi, Name 🚀") //TODO: vm
                .font(.largeTitle)
                .fontWeight(.semibold)
            Spacer()
        }
    }
    
    private var universityInfo: some View {
        Group {
            Text("University Name") //TODO: vm
            Text("Major Name") //TODO: vm
        }
        .font(.callout)
        .foregroundStyle(.secondary)
        .lineLimit(1)
    }
    
    private var userInfo: some View {
        HStack() {
            Circle()
                .frame(width: 100, height: 100)
                .padding(.trailing)
            
            VStack(alignment: .leading) {
                Text("Name and Surname") // TODO: vm
                Text("Student, year") //TODO: vm
                Text("Index") //TODO: vm
            }
            .foregroundStyle(.secondary)
            .font(.callout)
            
            
            Spacer()
        }
    }
}
