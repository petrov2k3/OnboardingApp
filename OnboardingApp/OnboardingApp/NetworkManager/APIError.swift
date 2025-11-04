//
//  APIError.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 04.11.2025.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case decodingError(Error)
    case networkError(Error)
}
