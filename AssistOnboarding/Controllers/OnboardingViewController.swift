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
                static let cellSize = CGSize(width: 360, height: 254)
                static let minimumLineSpacingForSection: CGFloat = 16
                static let insetForSection = UIEdgeInsets(top: 0, left: 31, bottom: 0, right: 31)
            }
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var onboardingCollectionView: UICollectionView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
    }
    
    // MARK: - Private
    
    private func registerCell() {
        let cell = UINib(nibName: Constants.CollectionView.CellIdentifiers.onboardingCell, bundle: nil)
        onboardingCollectionView.register(cell, forCellWithReuseIdentifier: Constants.CollectionView.CellIdentifiers.onboardingCell)
    }
}

// MARK: - CollectionView delegate, dataSource, delegateFlowLayout

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = onboardingCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionView.CellIdentifiers.onboardingCell, for: indexPath) as? OnboardingCell else {
            fatalError("Error: OnboardingCollectionView - not loaded")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = onboardingCollectionView.bounds.width - 62
        let height = onboardingCollectionView.bounds.height

        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.CollectionView.Configuration.minimumLineSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.CollectionView.Configuration.insetForSection
    }
}
