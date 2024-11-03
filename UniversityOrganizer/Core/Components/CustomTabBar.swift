//
//  CustomTabBar.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 03/11/2024.
//

import SwiftUI

struct CustomTabBar: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var activeTab: TabModel
    @Namespace private var animation
    @State private var tabLocation = CGRect.zero
    
    var activeForeground = Color.white
    var activeBackground = Color.blue
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(TabModel.allCases, id: \.rawValue) { tab in
                    Button {
                        activeTab = tab
                    } label: {
                        tabBarButtonLabel(tab)
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(alignment: .leading) {
                Capsule()
                    .fill(activeBackground.gradient)
                    .frame(width: tabLocation.width, height: tabLocation.height)
                    .offset(x: tabLocation.minX)
            }
            .coordinateSpace(.named("TABBARVIEW"))
            .padding(.horizontal, 5)
            .frame(height: 45)
            .background(
                .background
                    .shadow(
                        .drop(
                            color: colorScheme == .dark ? .white.opacity(0.08) : .black.opacity(0.08),
                            radius: 5, x: 5, y: 5
                        )
                    )
                    .shadow(
                        .drop(
                            color: colorScheme == .dark ? .white.opacity(0.06) : .black.opacity(0.06),
                            radius: 5, x: -5, y: -5
                        )
                    ),
                in: .capsule
            )
            .zIndex(10)
        }
        .padding(.bottom, 5)
        .animation(.smooth(duration: 0.3, extraBounce: 0), value: activeTab)
    }
}

#Preview {
    ContentView()
}

extension CustomTabBar {
    private func tabBarButtonLabel(_ tab: TabModel) -> some View {
        HStack(spacing: 5) {
            Image(systemName: tab.rawValue)
                .font(.title3)
                .frame(width: 30, height: 30)
            
            if activeTab == tab {
                Text(tab.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
            }
        }
        .foregroundStyle(activeTab == tab ? activeForeground : .secondary)
        .padding(.vertical, 2)
        .padding(.leading, 10)
        .padding(.trailing, 15)
        .contentShape(.rect)
        .background {
            if activeTab == tab {
                Capsule()
                    .fill(.clear)
                    .onGeometryChange(for: CGRect.self, of: {
                        $0.frame(in: .named("TABBARVIEW"))
                    }, action: { newValue in
                        tabLocation = newValue
                    })
                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
            }
        }
    }
}
