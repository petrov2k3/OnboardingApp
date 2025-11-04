//
//  QuestionPresenter.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 03.11.2025.
//

import Foundation

protocol QuestionPresenterProtocol {
    func viewDidLoad()
    func didSelectAnswer(at index: Int)
    func didTapContinue()
}

final class QuestionPresenter: QuestionPresenterProtocol {

    weak var vc: QuestionViewControllerProtocol?

    private let question: OnboardingQuestion
    private let onFinish: EmptyClosure

    private(set) var selectedIndex: Int? {
        didSet {
            vc?.updateContinueButton(isEnabled: selectedIndex != nil)
            vc?.reloadAnswers()
        }
    }

    init(question: OnboardingQuestion, onFinish: @escaping EmptyClosure) {
        self.question = question
        self.onFinish = onFinish
    }

    func viewDidLoad() {
        vc?.updateContinueButton(isEnabled: false)
        vc?.reloadAnswers()
    }

    func didSelectAnswer(at index: Int) {
        selectedIndex = index
    }

    func didTapContinue() {
        guard selectedIndex != nil else { return }
        
        // TODO: save the answer, send it somewhere, etc
        
        onFinish()
    }

    var questionTitle: String {
        question.question
    }

    var numberOfAnswers: Int {
        question.answers.count
    }

    func answerText(at index: Int) -> String {
        question.answers[index]
    }
}
