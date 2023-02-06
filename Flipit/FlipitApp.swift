//
//  FlipitApp.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/05.
//

import SwiftUI

@main
struct FlipitApp: App {
    
    @AppStorage("isOnboardingPresented") var isOnboardingPresented: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if (isOnboardingPresented == true) {
                onboardingView(isOnboardingPresented: $isOnboardingPresented)
                    .transition(.move(edge: .bottom))
            } else {
                MainView().transition(.opacity)
            }
        }
    }
}
