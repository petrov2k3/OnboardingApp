//
//  OnboardingFetcher.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 03.11.2025.
//

import Foundation

protocol OnboardingFetcherProtocol {
    func fetchOnboardingQuestions() async throws -> [OnboardingQuestion]
}

final class OnboardingFetcher: OnboardingFetcherProtocol {

    private let network: NetworkManager

    init(network: NetworkManager = .shared) {
        self.network = network
    }

    func fetchOnboardingQuestions() async throws -> [OnboardingQuestion] {
        let response: OnboardingResponse = try await network.request(.onboarding)
        
        return response.items
    }
}
