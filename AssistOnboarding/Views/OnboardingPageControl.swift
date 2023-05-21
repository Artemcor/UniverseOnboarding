//
//  OnboardingPageControl.swift
//  AssistOnboarding
//
//  Created by Artemcore on 20.05.2023.
//

import UIKit

class OnboardingPageControl: UIView {
    
    private struct Constants {
        struct Animation {
            static let duration = 0.5
        }
    }
    
    //MARK: - Variables
    
    @IBInspectable private var numberOfPages: Int = 0
    
    @IBInspectable private var currentPage: Int = 0 {
        didSet {
            reloadView()
        }
    }
    
    private let activePageSize = CGSize(width: 25, height: 4)
    private let inactivePageSize = CGSize(width: 14, height: 4)
        
    private let activePageColor = UIColor(red: 0, green: 0.605, blue: 1, alpha: 1)
    private let inactivePageColor = UIColor.gray
        
    private var pageViews = [UIView]()
    
    private let spacing = 8
    private let cornerRadius: CGFloat = 2
    
    private var isViewAppeared = true
    
    lazy var extraWidth = {
        activePageSize.width - inactivePageSize.width
    }()
    
    // MARK: - Lifecycle
    
    init(numberOfPages: Int, currentPage: Int) {
        self.numberOfPages = numberOfPages
        self.currentPage = currentPage
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    // MARK: - Public
    
    func stepToNextPage() {
        currentPage += 1
    }
    
    // MARK: - Private
    
    private func updatePagesColor() {
        pageViews.forEach {
            if $0 == pageViews[currentPage] {
                $0.backgroundColor = activePageColor
            } else {
                $0.backgroundColor = inactivePageColor
            }
        }
    }
    
    private func configureView() {
        (0..<numberOfPages).forEach { _ in
            let view = UIView()
            view.layer.cornerRadius = cornerRadius
            addSubview(view)
            pageViews.append(view)
            updatePagesColor()
        }
    }
    
    private func reloadView() {
        guard pageViews.indices.contains(currentPage) else { return }
        
        updatePagesColor()
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var originX = 0
        var duration = Constants.Animation.duration
        
        if isViewAppeared {
            duration = 0.0
            isViewAppeared = false
        }
        
        for view in pageViews {
            var size = CGSize()
            
            if view == pageViews[currentPage] {
                size = activePageSize
            } else {
                size = inactivePageSize
            }
            
            UIView.animate(withDuration: duration) {
                view.frame = CGRect(origin: CGPoint(x: originX, y: 0), size: size)
            }
            
            originX = originX + Int(size.width) + spacing
        }
    }
}
