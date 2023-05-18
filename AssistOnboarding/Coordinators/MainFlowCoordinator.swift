//
//  MainFlowCoordinator.swift
//  AssistOnboarding
//
//  Created by Artemcore on 18.05.2023.
//

import Foundation
import UIKit

class MainFlowCoordinator {
    
    private struct Constants {
        struct nibNames {
            static let onboardingScreen = "OnboardingScreen"
        }
    }
    
    // MARK: - Variables
    
    var router: MainRouter?

    // MARK: - Constants
    
    private let window: UIWindow
    
    // MARK: - Initializers
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Public
    
    func createFlow() {
        let onboardingViewController = OnboardingViewController(nibName: Constants.nibNames.onboardingScreen, bundle: nil)
        
        window.rootViewController = onboardingViewController
        router = MainRouter(initialController: onboardingViewController)
        window.makeKeyAndVisible()
    }
}
