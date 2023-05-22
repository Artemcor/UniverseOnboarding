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
    private let purchaseManager = PurchaseManager()
    
    // MARK: - Initializers
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Public
    
    func createFlow() {
        let model = OnboardingScreensModel()
        let onboardingViewController = OnboardingViewController(nibName: Constants.nibNames.onboardingScreen,
                                                                bundle: nil,
                                                                model: model,
                                                                purchaseManager: purchaseManager)
        
        window.rootViewController = onboardingViewController
        router = MainRouter(initialController: onboardingViewController)
        window.makeKeyAndVisible()
    }
}
