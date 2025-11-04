//
//  NetworkManager.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 03.11.2025.
//

import Foundation

final class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    private init() {}

    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        let request = endpoint.urlRequest

        let (data, response) = try await URLSession.shared.data(for: request)

        // TODO: handle APIError.networkError(error)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
