//
//  PaywallPresenter.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 04.11.2025.
//

import Foundation
import StoreKit

protocol PaywallPresenterProtocol {
    func viewDidLoad()
    func didTapBuy()
    func didTapClose()
}

final class PaywallPresenter: PaywallPresenterProtocol {

    weak var vc: PaywallViewControllerProtocol?

    private let subscriptionService: SubscriptionServiceProtocol
    private let onClose: EmptyClosure

    private var product: Product?

    init(
        subscriptionService: SubscriptionServiceProtocol = SubscriptionService(),
        onClose: @escaping EmptyClosure
    ) {
        self.subscriptionService = subscriptionService
        self.onClose = onClose
    }

    func viewDidLoad() {
        vc?.setPurchaseButtonEnabled(false)
        vc?.setLoading(true)

        Task {
            await loadProduct()
        }
    }

    func didTapBuy() {
        guard let product = product else { return }

        vc?.setLoading(true)
        vc?.setPurchaseButtonEnabled(false)

        Task {
            await purchase(product: product)
        }
    }

    func didTapClose() {
        onClose()
    }

    // MARK: - Private

    private func loadProduct() async {
        do {
            let product = try await subscriptionService.loadProduct()
            
            await MainActor.run {
                self.product = product
                self.vc?.setLoading(false)
                self.vc?.setPurchaseButtonEnabled(true)
                self.vc?.updatePriceText(product.displayPrice)
            }
            
        } catch {
            await MainActor.run {
                self.vc?.setLoading(false)
                self.vc?.showError(message: "Failed to load subscription. Please try again.")
            }
        }
    }

    private func purchase(product: Product) async {
        do {
            let transaction = try await subscriptionService.purchase(product: product)
            
            await MainActor.run {
                self.vc?.setLoading(false)
                self.vc?.setPurchaseButtonEnabled(true)

                if transaction != nil {
                    self.onClose()
                }
            }
        } catch {
            await MainActor.run {
                self.vc?.setLoading(false)
                self.vc?.setPurchaseButtonEnabled(true)
                self.vc?.showError(message: "Purchase failed. Please try again.")
            }
        }
    }
}
