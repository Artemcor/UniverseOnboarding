//
//  OnboardingButton.swift
//  AssistOnboarding
//
//  Created by Artemcore on 21.05.2023.
//

import UIKit

class OnboardingButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = bounds.height / 2
        backgroundColor = .white
    }

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .gray.withAlphaComponent(0.6) : .white
        }
    }
}
