//
//  RouterProtocol.swift
//  AssistOnboarding
//
//  Created by Artemcore on 18.05.2023.
//

import UIKit

protocol RouterProtocol {
    func present(_ controller: UIViewController, animated: Bool, presentationStyle: UIModalPresentationStyle)
    func dismiss(animated: Bool)
}
