//
//  OnboardingScreensModel.swift
//  AssistOnboarding
//
//  Created by Artemcore on 18.05.2023.
//

import UIKit

struct OnboardingScreenModel {
    let id: Int
    let mainTitle: String
    let secondaryTitle: NSAttributedString
}

struct OnboardingScreensModel {
    let onboardingModel: [OnboardingScreenModel]
    
    init() {
        let screen3AttributedString = NSMutableAttributedString(string: "7-Day Free Trial,\nthen $19.99 /month, auto-renewable" , attributes: [.font: UIFont.systemFont(ofSize: 16.0)])
        
        screen3AttributedString.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .bold)], range: (screen3AttributedString.string as NSString).range(of: "$19.99"))
                
        onboardingModel = [
            OnboardingScreenModel(id: 0,
                                  mainTitle: "Your Personal \nAssistant",
                                  secondaryTitle: NSAttributedString("Simplify your life \nwith an AI companion")),
            OnboardingScreenModel(id: 1,
                                  mainTitle: "Get assistance \nwith any topic",
                                  secondaryTitle: NSAttributedString("From daily tasks to complex \nqueries, we’ve got you covered")),
            OnboardingScreenModel(id: 2,
                                  mainTitle: "Perfect copy \nyou can rely on",
                                  secondaryTitle: NSAttributedString("Generate professional \ntexts effortlessly")),
            OnboardingScreenModel(id: 3,
                                  mainTitle: "Upgrade for Unlimited \nAI Capabilities",
                                  secondaryTitle: screen3AttributedString)
        ]
    }
}
