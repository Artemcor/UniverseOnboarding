//
//  AdaptiveLayoutConstraint.swift
//  AssistOnboarding
//
//  Created by Artemcore on 22.05.2023.
//


import UIKit

@IBDesignable
class AdaptiveLayoutConstraint: NSLayoutConstraint {
    
    //MARK: - iPhones
    @IBInspectable
    public var constant4and7inch: CGFloat = 0.0 {
        didSet {
            if isiPhone4and7Inch() {
                self.constant = self.constant4and7inch
            }
        }
    }
    
    func isiPhone4and7Inch() -> Bool {
        return (UIScreen.main.bounds.size.height == 667)
    }
}
