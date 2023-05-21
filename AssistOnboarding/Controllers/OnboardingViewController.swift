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
    @IBOutlet private weak var termsTextView: UITextView!
    @IBOutlet private weak var onboardingButton: UIButton!
    @IBOutlet private weak var onboardingPageControl: OnboardingPageControl!
    
    // MARK: - Variables
    
    private let onboardingModel: [OnboardingScreenModel]
    private var continueButtonClick = 0

    lazy private var cellWidth = {
        onboardingCollectionView.bounds.width - Constants.CollectionView.Configuration.insetForSection.left * 2
    }()
    
    lazy private var cellSize = {
        let width = cellWidth
        let height = onboardingCollectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }()
    
    // MARK: - Lifecycle

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, model: OnboardingScreensModel) {
        onboardingModel = model.onboardingModel
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureOnboardingCollectionView()
        registerCell()
        configureTermsTextView()
    }
    
    // MARK: - Actions
    
    @IBAction private func continueButton(_ sender: Any) {
        let contentOffSet = onboardingCollectionView.contentOffset
        let additionalWidth = cellWidth + Constants.CollectionView.Configuration.minimumLineSpacingForSection
        
        if contentOffSet.x + additionalWidth + 2 * Constants.CollectionView.Configuration.insetForSection.left < onboardingCollectionView.contentSize.width {
            
            continueButtonClick += 1
            
            configureTermsPageControlViews()
            onboardingPageControl.stepToNextPage()
            
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
    
    private func configureTermsTextView() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray, .paragraphStyle: paragraphStyle]

        let attributedString = NSMutableAttributedString(string: "By continuing you accept our: \nTerms of Use, Privacy Policy and Subscription Terms", attributes: attributes)
        
        attributedString.addAttribute(.link, value: "https://assistai.guru/documents/tos.html", range: (attributedString.string as NSString).range(of: "Terms of Use"))
        attributedString.addAttribute(.link, value: "https://assistai.guru/documents/privacy.html", range: (attributedString.string as NSString).range(of: "Privacy Policy"))
        attributedString.addAttribute(.link, value: "https://assistai.guru/documents/subscription.html", range: (attributedString.string as NSString).range(of: "Subscription Terms"))
        
        termsTextView.isSelectable = true
        termsTextView.isEditable = false

        termsTextView.attributedText = attributedString
    }
    
    private func configureTermsPageControlViews() {
        if continueButtonClick == 1 || continueButtonClick == onboardingModel.count - 1 {
            onboardingPageControl.isHidden.toggle()
            termsTextView.isHidden.toggle()
        }
    }
}

// MARK: - CollectionView delegate, dataSource, delegateFlowLayout

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = onboardingCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionView.CellIdentifiers.onboardingCell, for: indexPath) as? OnboardingCell else {
            fatalError("Error: OnboardingCollectionView - not loaded")
        }
        
        let model = onboardingModel[indexPath.item]
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

// MARK: - TextView delegate

extension OnboardingViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.delegate = nil
        textView.selectedTextRange = nil
        textView.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
