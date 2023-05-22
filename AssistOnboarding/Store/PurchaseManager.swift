//
//  SubscriptionProducts.swift
//  AssistOnboarding
//
//  Created by Artemcore on 22.05.2023.
//

import StoreKit

enum ProductType: String {
    case oneMonth
    
    var identifier: String {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return "" }
        
        switch self {
        case .oneMonth:
            return "\(bundleIdentifier).premium.onemonth"
        }
    }
    
    init?(identifier: String) {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return nil }
        
        switch identifier {
        case "\(bundleIdentifier).premium.onemonth":
            self = .oneMonth
        default:
            return nil
        }
    }
}

class PurchaseManager {
    
    private let productIds: Set<String> = [ProductType.oneMonth.identifier]
    private var purchasedProductIDs = Set<String>()
    private(set) var products: [Product] = []
    private var updates: Task<Void, Never>? = nil
    private var productsLoaded = false
    
    // MARK: - Lifecycle
    
    init() {
        Task {
            await updatePurchasedProducts()
        }
        
        updates = observeTransactionUpdates()
    }

    deinit {
        updates?.cancel()
    }
    
    // MARK: - Public

    func loadProducts() async throws {
        guard !productsLoaded else { return }
        
        products = try await Product.products(for: productIds)
        productsLoaded = true
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await self.updatePurchasedProducts()
        case let .success(.unverified(_, error)):
            print(error.localizedDescription)
            break
        case .pending:
            break
        case .userCancelled:
            break
        @unknown default:
            break
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }

            if transaction.revocationDate == nil {
                purchasedProductIDs.insert(transaction.productID)
            } else {
                purchasedProductIDs.remove(transaction.productID)
            }
        }

    }
    
    // MARK: - Private

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await _ in Transaction.updates {
                await self.updatePurchasedProducts()
            }
        }
    }
}
