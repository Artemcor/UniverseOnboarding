//
//  OnboardingScreensModel.swift
//  AssistOnboarding
//
//  Created by Artemcore on 18.05.2023.
//

import Foundation

struct OnboardingScreenModel {
    let id: Int
    let mainTitle: String
    let secondaryTitle: String
}

struct OnboardingScreensModel {
    let onboardingsModel: [OnboardingScreenModel]
    
    init() {
        onboardingsModel = [
            OnboardingScreenModel(id: 0,
                                  mainTitle: "Your Personal Assistant",
                                  secondaryTitle: "Simplify your life with an AI companion"),
            OnboardingScreenModel(id: 1,
                                  mainTitle: "Get assistance with any topic",
                                  secondaryTitle: "From daily tasks to complex queries, we’ve got you covered"),
            OnboardingScreenModel(id: 2,
                                  mainTitle: "Perfect copy you can rely on",
                                  secondaryTitle: "Generate professional texts effortlessly"),
            OnboardingScreenModel(id: 3,
                                  mainTitle: "Upgrade for Unlimited AI Capabilities",
                                  secondaryTitle: "then $19.99 /month, auto-renewable")
        ]
    }
}
