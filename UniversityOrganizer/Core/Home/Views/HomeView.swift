//
//  HomeView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 03/11/2024.
//

import SwiftUI

struct ParralexEffect: View {
    var body: some View {
        GeometryReader { geo in
            let offsetY = geo.frame(in: .global).minY
            let isScrolled = offsetY > 0
            let height = geo.size.height
            
            Spacer()
                .frame(height: isScrolled ? height + offsetY : height)
                .background {
                    LinearGradient.customGradient.customBackground()
                        .offset(y: isScrolled ? -offsetY : 0)
                }
        }
    }
}

struct HomeView: View {
    var safeAreaInsets: EdgeInsets
    
    var body: some View {
        ScrollView {
            HomeUserView()
                .padding()
                .padding(.top, safeAreaInsets.top)
                .background(ParralexEffect())

            newsView(text: "X tasks to complete") // TODO: vm
                .padding(.leading)
                .foregroundStyle(Color.theme.green)

            newsView(text: "X deadlines this week") // TODO: vm
                .padding(.leading)
                .foregroundStyle(Color.theme.red)

            newsView(text: "X new marks last week") // TODO: vm
                .padding(.leading)
                .foregroundStyle(Color.theme.blue)
        
            upcomingClassSection
        
            gpaSection

            Spacer()
        }
        .scrollIndicators(.hidden)
        .safeAreaPadding(.bottom, 100)
        .ignoresSafeArea()
    }
    
    func newsView(text: String) -> some View {
        HStack {
            Image(systemName: "circle.fill")
                .font(.caption)
            
            Text(text)
            
            Spacer()
        }
    }
}

#Preview {
    GeometryReader { geo in
        HomeView(safeAreaInsets: geo.safeAreaInsets)
    }
}

extension HomeView {
    private var gpaSection : some View {
        VStack {
            HStack {
                Image(systemName: "chart.pie")
                Text("Summary")
                Spacer()
            }
            .padding()
            .font(.title)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.theme.background)
                    .customShadow()
                
                VStack() {
                    Text("Current GPA")
                        .foregroundStyle(.secondary)
                        .padding(.top)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "graduationcap.circle")
                        Text("4.20")
                    }
                    
                    Spacer()
                }
                .font(.title3)
                .fontWeight(.semibold)
                .padding()
            }
            .padding(.horizontal, 40)
        }
    }
    
    private var upcomingClassSection : some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "calendar.circle")
                Text("Upcoming class")
                Spacer()
            }
            .padding()
            .font(.title)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.theme.background)
                    .customShadow()
                
                VStack(alignment: .leading) {
                    Text("Cybersecurity Lab") //TODO: vm
                        .font(.title2)
                    
                    Spacer()
                    
                    Text("Friday, 14 October") //TODO: vm
                    
                    HStack {
                        Image(systemName: "timer.circle")
                        Text("10:00 - 12:00") //TODO: vm
                    }
                    
                    HStack {
                        Image(systemName: "timer.circle")
                        Text("Z-7, 188") //TODO: vm
                    }
                }
                .padding()
                .lineLimit(1)
            }
            .padding(.horizontal, 40)
        }
    }
    
}
