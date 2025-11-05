//
//  SubscriptionService.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 04.11.2025.
//

import Foundation
import StoreKit

protocol SubscriptionServiceProtocol {
    func loadProduct() async throws -> Product
    func purchase(product: Product) async throws -> Transaction?
    
    ///__ may not use it yet, but the methods are ready
    func hasActiveSubscription() async -> Bool
    
    ///__ restore methods is good if in the future we will add the Restore button to Paywall screen, as it's recommended by Apple guidelines
    func restore() async throws
}

enum SubscriptionError: Error {
    case productNotFound
    case unverifiedTransaction
}

final class SubscriptionService: SubscriptionServiceProtocol {
    
    static let shared: SubscriptionService = SubscriptionService()
    private init() {}

    private let productIds = ["com.ivanpetrov.OnboardingApp.weekly_premium"]

    func loadProduct() async throws -> Product {
        let products = try await Product.products(for: productIds)
        
        guard let product = products.first else {
            throw SubscriptionError.productNotFound
        }
        
        return product
    }

    func purchase(product: Product) async throws -> Transaction? {
        let result = try await product.purchase()

        switch result {
        case .success(let verificationResult):
            let transaction = try checkVerified(verificationResult)
            await transaction.finish()
            return transaction

        case .pending, .userCancelled:
            return nil

        @unknown default:
            return nil
        }
    }
    
    func hasActiveSubscription() async -> Bool {
        
        // TODO: here we can decide whether to show the paywall / change the UI
        
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                if productIds.contains(transaction.productID) {
                    return true
                }
            case .unverified:
                continue
            }
        }
        return false
    }
    
    func restore() async throws {
        for await result in Transaction.currentEntitlements {
            _ = try checkVerified(result)
        }
    }
    
    func startObservingTransactionUpdates() {
        Task.detached { [productIds] in
            for await result in Transaction.updates {
                do {
                    let transaction = try await MainActor.run {
                        try self.checkVerified(result)
                    }
                    
                    if productIds.contains(transaction.productID) {
                        
                        // TODO: Here we can pull NotificationCenter / refresh state
                        
                        await transaction.finish()
                    }
                } catch {
                    
                    // TODO: show alert, for now it's just log
                    
                    print("Failed to verify transaction from updates: \(error)")
                }
            }
        }
    }
    
    // MARK: - Private

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw SubscriptionError.unverifiedTransaction
        case .verified(let signedType):
            return signedType
        }
    }
}
