//
//  QuestionViewController.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 03.11.2025.
//

import UIKit
import SnapKit

protocol QuestionViewControllerProtocol: AnyObject {
    func updateContinueButton(isEnabled: Bool)
    func reloadAnswers()
}

final class QuestionViewController: UIViewController {

    // MARK: - UI
    
    private let lbTitle: UILabel = UILabel()
    private let lbQuestion: UILabel = UILabel()
    private let tvAnswers: UITableView = UITableView()
    private let btContinue: UIButton = UIButton(type: .system)

    // MARK: - Properties
    
    private let presenter: QuestionPresenter
    
    // MARK: - Inits
    
    init(presenter: QuestionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.vc = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        layoutUI()
        
        setupActions()
        
        presenter.viewDidLoad()
    }

    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = Theme.Colors.mainBackgroundScreen

        lbTitle.text = "Let’s setup App for you"
        lbTitle.font = Theme.Fonts.title(26)
        lbTitle.textColor = Theme.Colors.mainTextBlack
        lbTitle.numberOfLines = 0
        
        lbQuestion.text = presenter.questionTitle
        lbQuestion.font = Theme.Fonts.subtitle()
        lbQuestion.textColor = Theme.Colors.mainTextBlack
        lbQuestion.numberOfLines = 0
        
        tvAnswers.backgroundColor = .clear
        tvAnswers.separatorStyle = .none
        tvAnswers.showsVerticalScrollIndicator = false
        tvAnswers.dataSource = self
        tvAnswers.delegate = self
        tvAnswers.register(AnswerCell.self, forCellReuseIdentifier: AnswerCell.reuseId)
        tvAnswers.rowHeight = UITableView.automaticDimension
        tvAnswers.estimatedRowHeight = 52
        
        btContinue.setTitle("Continue", for: .normal)
        btContinue.titleLabel?.font = Theme.Fonts.body(17, weight: .semibold)
        btContinue.layer.cornerRadius = 28
        btContinue.clipsToBounds = true
        
        configureContinueButton(isEnabled: false)
    }
    
    private func layoutUI() {
        view.addSubviews(lbTitle, lbQuestion, tvAnswers, btContinue)
        
        lbTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        lbQuestion.snp.makeConstraints {
            $0.top.equalTo(lbTitle.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        btContinue.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(48)
            $0.height.equalTo(56)
        }
        
        tvAnswers.snp.makeConstraints {
            $0.top.equalTo(lbQuestion.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(btContinue.snp.top).offset(-16)
        }
    }
    
    private func setupActions() {
        btContinue.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
    }
    
    private func configureContinueButton(isEnabled: Bool) {
        btContinue.isEnabled = isEnabled
        
        if isEnabled {
            btContinue.backgroundColor = Theme.Colors.buttonBackgroundBlack
            btContinue.setTitleColor(.white, for: .normal)
        } else {
            btContinue.backgroundColor = .white
            btContinue.setTitleColor(Theme.Colors.buttonTextGray, for: .normal)
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapContinue() {
        presenter.didTapContinue()
    }
}

// MARK: - QuestionViewControllerProtocol

extension QuestionViewController: QuestionViewControllerProtocol {
    func updateContinueButton(isEnabled: Bool) {
        configureContinueButton(isEnabled: isEnabled)
    }

    func reloadAnswers() {
        tvAnswers.reloadData()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension QuestionViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfAnswers
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AnswerCell.reuseId,
            for: indexPath
        ) as? AnswerCell else {
            return UITableViewCell()
        }
        
        let text = presenter.answerText(at: indexPath.row)
        let isSelected = presenter.selectedIndex == indexPath.row
        
        cell.configure(text: text, isSelected: isSelected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectAnswer(at: indexPath.row)
    }
}
