//
//  OnboardingQuestion.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 03.11.2025.
//

import Foundation

struct OnboardingResponse: Decodable {
    let items: [OnboardingQuestion]
}

struct OnboardingQuestion: Decodable {
    let id: Int
    let question: String
    let answers: [String]
}
