//
//  OnboardingFlow.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 03.11.2025.
//

import UIKit

enum OnboardingStep {
    case question(OnboardingQuestion)
    case paywall
}

final class OnboardingFlow {

    private weak var presentingViewController: UIViewController?
    private var navigationController: UINavigationController?

    private let fetcher: OnboardingFetcherProtocol
    private var steps: [OnboardingStep] = []

    init(fetcher: OnboardingFetcherProtocol = OnboardingFetcher()) {
        self.fetcher = fetcher
    }

    func run(from viewController: UIViewController) async {
        self.presentingViewController = viewController

        do {
            try await loadSteps()
        } catch {
            
            // TODO: handle error (maybe show alert)
            
            print("Failed to load onboarding: \(error)")
            return
        }

        await runSteps()
        finishFlow()
    }

    private func loadSteps() async throws {
        let questions = try await fetcher.fetchOnboardingQuestions()
        
        steps = questions.map { OnboardingStep.question($0) }
        steps.append(.paywall)
    }

    private func runSteps() async {
        guard !steps.isEmpty else { return }

        await withCheckedContinuation { continuation in
            let firstStep = steps[0]
            let firstVC = makeViewController(for: firstStep, at: 0, continuation: continuation)

            let navigationController = UINavigationController(rootViewController: firstVC)
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.setNavigationBarHidden(true, animated: false)
            
            self.navigationController = navigationController

            presentingViewController?.present(navigationController, animated: false)
        }
    }

    private func makeViewController(
        for step: OnboardingStep,
        at index: Int,
        continuation: CheckedContinuation<Void, Never>
    ) -> UIViewController {
        
        switch step {
        case .question(let question):
            let presenter = QuestionPresenter(question: question) { [weak self] in
                self?.showNextStep(from: index, continuation: continuation)
            }
            
            return QuestionViewController(presenter: presenter)

        case .paywall:
            let paywallVC = PaywallViewController { [weak self] in
                continuation.resume()
                self?.navigationController?.dismiss(animated: true)
            }
            
            return paywallVC
        }
    }

    private func showNextStep(
        from currentIndex: Int,
        continuation: CheckedContinuation<Void, Never>
    ) {
        let nextIndex = currentIndex + 1
        
        guard nextIndex < steps.count,
              let navigationController = navigationController
        else {
            continuation.resume()
            return
        }

        let nextStep = steps[nextIndex]
        let nextVC = makeViewController(for: nextStep, at: nextIndex, continuation: continuation)

        navigationController.setViewControllers([nextVC], animated: true)
    }

    private func finishFlow() {
        presentingViewController?.dismiss(animated: true)
    }
}
