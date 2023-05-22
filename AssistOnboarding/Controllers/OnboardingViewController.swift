//
//  ViewController.swift
//  AssistOnboarding
//
//  Created by Artemcore on 18.05.2023.
//

import UIKit
import Combine
import StoreKit

class OnboardingViewController: UIViewController {
    
    private enum AlertType {
        case restorePurchase
        case crossMark
        case error(String)
    }
    
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
    @IBOutlet private weak var restoreButton: UIButton!
    @IBOutlet private weak var crossButton: UIButton!
    
    // MARK: - Variables
    
    private let continueSubject = PassthroughSubject<Void, Never>()
    private let alertSubject = PassthroughSubject<AlertType, Never>()
    private var cancelable = Set<AnyCancellable>()
    
    private let onboardingModel: [OnboardingScreenModel]
    private let purchaseManager: PurchaseManager

    private var onboardingButtonClick = 0

    lazy private var cellWidth = {
        onboardingCollectionView.bounds.width - Constants.CollectionView.Configuration.insetForSection.left * 2
    }()
    
    lazy private var cellSize = {
        let width = cellWidth
        let height = onboardingCollectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }()
    
    // MARK: - Lifecycle

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, model: OnboardingScreensModel, purchaseManager: PurchaseManager) {
        onboardingModel = model.onboardingModel
        self.purchaseManager = purchaseManager
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        subscribeToPublishers()
        loadProducts()
    }
    
    // MARK: - Actions
    
    @IBAction private func continueButtonAction(_ sender: Any) {
        continueSubject.send()
    }
    
    @IBAction private func restoreButtonAction(_ sender: Any) {
        Task {
            try await AppStore.sync()
        }
    }
    
    @IBAction private func crossButtonAction(_ sender: Any) {
        alertSubject.send(.crossMark)
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
    
    private func subscribeToPublishers() {
        continueSubject.sink { [self] in
            let contentOffSet = onboardingCollectionView.contentOffset
            let additionalWidth = cellWidth + Constants.CollectionView.Configuration.minimumLineSpacingForSection
            
            if contentOffSet.x + additionalWidth + 2 * Constants.CollectionView.Configuration.insetForSection.left < onboardingCollectionView.contentSize.width {
                
                onboardingButtonClick += 1
                
                configureVisibilityOfTermsPageControlViews()
                configureOnboardingButton()
                onboardingPageControl.stepToNextPage()
                
                UIView.animate(withDuration: 0.8,
                               delay: 0,
                               usingSpringWithDamping: 0.85,
                               initialSpringVelocity: 1,
                               options: .curveLinear) {

                    self.onboardingCollectionView.contentOffset = CGPoint(x: contentOffSet.x + additionalWidth, y: 0)
                    self.onboardingCollectionView.layoutIfNeeded()
                }
            } else {
                guard let product = purchaseManager.products.first(where: { $0.id == ProductType.oneMonth.identifier }) else {
                    alertSubject.send(.error("Error - product nor found"))
                    return
                }
                Task {
                    try await purchaseManager.purchase(product)
                }
            }
        }
        .store(in: &cancelable)
        
        alertSubject.sink { [self] alertType in
            switch alertType {
            case .restorePurchase:
                present(AlertService.restoreAlert { }, animated: true)
            case .crossMark:
                present(AlertService.crossAlert { }, animated: true)
            case .error(let message):
                present(AlertService.errorAlert(message: message) { }, animated: true)
            }
        }
        .store(in: &cancelable)
    }
    
    private func configureVisibilityOfTermsPageControlViews() {
        if onboardingButtonClick == 1 || onboardingButtonClick == onboardingModel.count - 1 {
            if onboardingPageControl.isHidden {
                onboardingPageControl.fadeIn()
                termsTextView.fadeOut()
            } else {
                onboardingPageControl.fadeOut()
                termsTextView.fadeIn()
            }
        }
        
        if onboardingButtonClick == onboardingModel.count - 1 {
            restoreButton.isHidden = false
            crossButton.isHidden = false
        }
    }
    
    private func configureOnboardingButton() {
        if onboardingButtonClick == onboardingModel.count - 1 {
            UIView.performWithoutAnimation {
                self.onboardingButton.setTitle("Try Free & Subscribe", for: .normal)
                self.onboardingButton.layoutIfNeeded()
            }
        }
    }
    
    private func loadProducts() {
        Task {
            do {
                try await purchaseManager.loadProducts()
            } catch {
                print(error.localizedDescription)
            }
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
