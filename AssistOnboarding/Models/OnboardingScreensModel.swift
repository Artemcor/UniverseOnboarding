//
//  OnboardingScreensModel.swift
//  AssistOnboarding
//
//  Created by Artemcore on 18.05.2023.
//

import Foundation

struct OnboardingScreensModel {
    private let id: Int
    private let mainTitle: String
    private let secondaryTitle: String
    
    static let model = [
        OnboardingScreensModel(id: 0,
                               mainTitle: "Your Personal Assistant",
                               secondaryTitle: "Simplify your life with an AI companion"),
        OnboardingScreensModel(id: 1,
                               mainTitle: "Get assistance with any topic",
                               secondaryTitle: "From daily tasks to complex queries, we’ve got you covered"),
        OnboardingScreensModel(id: 2,
                               mainTitle: "Perfect copy you can rely on",
                               secondaryTitle: "Generate professional texts effortlessly"),
        OnboardingScreensModel(id: 3,
                               mainTitle: "Upgrade for Unlimited AI Capabilities",
                               secondaryTitle: "then $19.99 /month, auto-renewable")
    ]
    
}
