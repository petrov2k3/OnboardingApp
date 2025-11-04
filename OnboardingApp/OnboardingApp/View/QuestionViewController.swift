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
        presenter.viewDidLoad()
    }

    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .systemBackground

        lbTitle.font = .systemFont(ofSize: 22, weight: .bold)
        lbTitle.numberOfLines = 0
        lbTitle.text = presenter.questionTitle
        
        tvAnswers.dataSource = self
        tvAnswers.delegate = self

        btContinue.setTitle("Continue", for: .normal)
        btContinue.isEnabled = false
        btContinue.backgroundColor = .lightGray
        btContinue.setTitleColor(.white, for: .normal)
        btContinue.layer.cornerRadius = 24
        btContinue.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        
        view.addSubviews(lbTitle, tvAnswers, btContinue)
        
        lbTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        btContinue.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            $0.height.equalTo(52)
        }
        
        tvAnswers.snp.makeConstraints {
            $0.top.equalTo(lbTitle.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(btContinue.snp.top).offset(-16)
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
        btContinue.isEnabled = isEnabled
        btContinue.backgroundColor = isEnabled ? .systemGreen : .lightGray
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
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = presenter.answerText(at: indexPath.row)

        if presenter.selectedIndex == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectAnswer(at: indexPath.row)
    }
}
