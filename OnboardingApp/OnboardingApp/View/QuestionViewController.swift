//
//  QuestionViewController.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 03.11.2025.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol QuestionViewControllerProtocol: AnyObject {
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
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let selectedIndexRelay: BehaviorRelay<Int?> = BehaviorRelay<Int?>(value: nil)
    
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
        
        setupBindings()
        
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
        
        btContinue.configuration = ButtonConfiguration.defaultWhite(title: "Continue")
        btContinue.isEnabled = false
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
            $0.top.equalTo(lbQuestion.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(btContinue.snp.top).offset(-16)
        }
    }
    
    private func setupBindings() {
        btContinue.rx.tap
            .bind { [weak self] in
                self?.presenter.didTapContinue()
            }
            .disposed(by: disposeBag)
        
        tvAnswers.rx.itemSelected
            .map { $0.row }
            .bind { [weak self] row in
                guard let self else { return }
                
                self.selectedIndexRelay.accept(row)
                self.presenter.didSelectAnswer(at: row)
            }
            .disposed(by: disposeBag)
        
        let isContinueEnabled = selectedIndexRelay
            .map { $0 != nil }
            .distinctUntilChanged()
            .share(replay: 1)
        
        isContinueEnabled
            .bind(to: btContinue.rx.isEnabled)
            .disposed(by: disposeBag)
        
        isContinueEnabled
            .bind { [weak self] enabled in
                guard let self else { return }
                
                let title = "Continue"
                
                self.btContinue.configuration = enabled
                    ? ButtonConfiguration.defaultBlack(title: title)
                    : ButtonConfiguration.defaultWhite(title: title)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - QuestionViewControllerProtocol

extension QuestionViewController: QuestionViewControllerProtocol {
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
}
