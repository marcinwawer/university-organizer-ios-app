//
//  Toast.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 18/12/2024.
//

import SwiftUI

struct Toast: View {
    @Environment(\.colorScheme) var colorScheme
    
    let info: String
    let isPositive: Bool
    
    var body: some View {
        ZStack {
            toastBackground
            toastContent
        }
        .frame(width: 180, height: 180)
        .transition(.opacity)
        .onAppear { isPositive ? successsHapticFeedback() : errorHapticFeedback() }
    }
}

// MARK: VARIABLES
extension Toast {
    private var toastContent: some View {
        VStack {
            Image(systemName: isPositive ? "checkmark.circle" : "x.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
            
            Text(info)
                .multilineTextAlignment(.center)
        }
        .padding()
        .foregroundStyle(isPositive ? Color.theme.green : Color.theme.red)
    }
    
    private var toastBackground: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.thinMaterial)
            .shadow(
                color: colorScheme == .dark ? .white.opacity(0.4) : .black.opacity(0.4),
                radius: 12
            )
    }
}

// MARK: FUNCTIONS
extension Toast {
    private func successsHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    private func errorHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

#Preview {
    Toast(info: "Successfully changed profile picture!", isPositive: true)
}
