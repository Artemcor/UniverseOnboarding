//
//  ViewController.swift
//  AssistOnboarding
//
//  Created by Artemcore on 18.05.2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private struct Constants {
        
        struct CollectionView {
            struct CellIdentifiers {
                static let onboardingCell = "OnboardingCell"
            }
            
            struct Configuration {
                static let minimumLineSpacingForSection: CGFloat = 16
                static let insetForSection = UIEdgeInsets(top: 0, left: 31, bottom: 0, right: 31)
            }
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var onboardingCollectionView: UICollectionView!
    
    // MARK: - Variables
    
    let onboardingsModel: [OnboardingScreenModel]

    lazy var cellWidth = {
        onboardingCollectionView.bounds.width - Constants.CollectionView.Configuration.insetForSection.left * 2
    }()
    
    lazy var cellSize = {
        let width = cellWidth
        let height = onboardingCollectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }()
    
    // MARK: - Lifecycle

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, model: OnboardingScreensModel) {
        onboardingsModel = model.onboardingsModel
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureOnboardingCollectionView()
        registerCell()
    }
    
    // MARK: - Actions
    
    @IBAction private func continueButton(_ sender: Any) {
        let contentOffSet = onboardingCollectionView.contentOffset
        let additionalWidth = cellWidth + Constants.CollectionView.Configuration.minimumLineSpacingForSection
        
        if contentOffSet.x + additionalWidth + 2 * Constants.CollectionView.Configuration.insetForSection.left < onboardingCollectionView.contentSize.width {
            
            UIView.animate(withDuration: 0.8,
                           delay: 0,
                           usingSpringWithDamping: 0.85,
                           initialSpringVelocity: 1,
                           options: .curveLinear) {

                self.onboardingCollectionView.contentOffset = CGPoint(x: contentOffSet.x + additionalWidth, y: 0)
                self.onboardingCollectionView.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Private
    
    private func configureOnboardingCollectionView() {
        onboardingCollectionView.isScrollEnabled = false
    }
    
    private func registerCell() {
        let cell = UINib(nibName: Constants.CollectionView.CellIdentifiers.onboardingCell, bundle: nil)
        onboardingCollectionView.register(cell, forCellWithReuseIdentifier: Constants.CollectionView.CellIdentifiers.onboardingCell)
    }
}

// MARK: - CollectionView delegate, dataSource, delegateFlowLayout

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingsModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = onboardingCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionView.CellIdentifiers.onboardingCell, for: indexPath) as? OnboardingCell else {
            fatalError("Error: OnboardingCollectionView - not loaded")
        }
        
        let model = onboardingsModel[indexPath.item]
        let config = OnboardingCell.Configuration(id: model.id,
                                                  mainText: model.mainTitle,
                                                  secondaryText: model.secondaryTitle)
        cell.configure(config)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.CollectionView.Configuration.minimumLineSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.CollectionView.Configuration.insetForSection
    }
}
