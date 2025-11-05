//
//  QuestionPresenter.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 03.11.2025.
//

import Foundation

protocol QuestionPresenterProtocol {
    var selectedIndex: Int? { get }
    var questionTitle: String { get }
    var numberOfAnswers: Int { get }
    
    func viewDidLoad()
    func didSelectAnswer(at index: Int)
    func didTapContinue()
    func answerText(at index: Int) -> String
}

final class QuestionPresenter: QuestionPresenterProtocol {

    // MARK: - Properties
    
    weak var vc: QuestionViewControllerProtocol?

    private let question: OnboardingQuestion
    private let onFinish: EmptyClosure

    private(set) var selectedIndex: Int? {
        didSet {
            vc?.reloadAnswers()
        }
    }
    
    var questionTitle: String {
        question.question
    }

    var numberOfAnswers: Int {
        question.answers.count
    }
    
    // MARK: - Inits
    
    init(question: OnboardingQuestion, onFinish: @escaping EmptyClosure) {
        self.question = question
        self.onFinish = onFinish
    }
    
    // MARK: - QuestionPresenterProtocol

    func viewDidLoad() {
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

    func answerText(at index: Int) -> String {
        question.answers[index]
    }
}
