//
//  PaywallPresenter.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 04.11.2025.
//

import Foundation
import StoreKit

protocol PaywallView: AnyObject {
    func updatePriceText(_ priceText: String)
    func setLoading(_ isLoading: Bool)
    func setPurchaseButtonEnabled(_ isEnabled: Bool)
    func showError(message: String)
}

protocol PaywallPresenterProtocol {
    func viewDidLoad()
    func didTapBuy()
    func didTapClose()
}

final class PaywallPresenter: PaywallPresenterProtocol {

    weak var view: PaywallView?

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
        view?.setPurchaseButtonEnabled(false)
        view?.setLoading(true)

        Task {
            await loadProduct()
        }
    }

    func didTapBuy() {
        guard let product = product else { return }

        view?.setLoading(true)
        view?.setPurchaseButtonEnabled(false)

        Task {
            await purchase(product: product)
        }
    }

    func didTapClose() {
        onClose()
    }

    // MARK: - Private

    @MainActor
    private func handleLoaded(product: Product) {
        self.product = product
        view?.setLoading(false)
        view?.setPurchaseButtonEnabled(true)

        // Product.displayPrice уже содержит валюту, например "$6.99"
        view?.updatePriceText(product.displayPrice)
    }

    private func loadProduct() async {
        do {
            let product = try await subscriptionService.loadProduct()
            await MainActor.run {
                self.handleLoaded(product: product)
            }
        } catch {
            await MainActor.run {
                self.view?.setLoading(false)
                self.view?.showError(message: "Failed to load subscription. Please try again.")
            }
        }
    }

    private func purchase(product: Product) async {
        do {
            let transaction = try await subscriptionService.purchase(product: product)
            await MainActor.run {
                self.view?.setLoading(false)
                self.view?.setPurchaseButtonEnabled(true)

                if transaction != nil {
                    // покупка успешна — закрываем flow
                    self.onClose()
                }
            }
        } catch {
            await MainActor.run {
                self.view?.setLoading(false)
                self.view?.setPurchaseButtonEnabled(true)
                self.view?.showError(message: "Purchase failed. Please try again.")
            }
        }
    }
}
