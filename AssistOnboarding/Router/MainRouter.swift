//
//  MainRouter.swift
//  AssistOnboarding
//
//  Created by Artemcore on 18.05.2023.
//

import UIKit

class MainRouter: RouterProtocol {
    
    private var contollerStack = [UIViewController]()
    
    init(initialController: UIViewController) {
        contollerStack.append(initialController)
    }
    
    func present(_ controller: UIViewController, animated: Bool = true, presentationStyle: UIModalPresentationStyle = .fullScreen) {
        controller.modalPresentationStyle = presentationStyle
        contollerStack.last?.present(controller, animated: animated)
        contollerStack.append(controller)
    }
    
    func dismiss(animated: Bool = true) {
        contollerStack.last?.dismiss(animated: animated)
        contollerStack.removeLast()
    }
}
