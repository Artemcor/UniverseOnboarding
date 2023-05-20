//
//  OnboardingCell.swift
//  AssistOnboarding
//
//  Created by Artemcore on 18.05.2023.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
    
    struct Configuration {
        let id: Int
        let mainText: String
        let secondaryText: String
    }
    
    // MARK: - Outlets

    @IBOutlet private weak var illustrationImage: UIImageView!
    @IBOutlet private weak var mainLabel: UILabel!
    @IBOutlet private weak var secondaryLabel: UILabel!
    
    // MARK: - Public

    func configure(_ configuration: Configuration) {
        illustrationImage.image = UIImage(named: "OnboardingIllustration\(configuration.id)")
        mainLabel.text = configuration.mainText
        secondaryLabel.text = configuration.secondaryText
    }
}
