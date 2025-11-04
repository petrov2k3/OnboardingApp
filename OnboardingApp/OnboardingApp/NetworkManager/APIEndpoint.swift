//
//  APIEndpoint.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 04.11.2025.
//

import Foundation

enum APIEndpoint {
    case onboarding

    private var baseURL: String {
        "https://test-ios.universeapps.limited/"
    }

    var urlRequest: URLRequest {
        switch self {
        case .onboarding:
            let url = URL(string: "\(baseURL)onboarding")!
            return URLRequest(url: url)
        }
    }
}
