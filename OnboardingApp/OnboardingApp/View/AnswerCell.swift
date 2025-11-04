//
//  AnswerCell.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 04.11.2025.
//

import UIKit
import SnapKit

final class AnswerCell: UITableViewCell {

    static let reuseId = "AnswerCell"

    private let containerView = UIView()
    private let answerLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        containerView.backgroundColor = .white

        answerLabel.font = .systemFont(ofSize: 16, weight: .regular)
        answerLabel.textColor = UIColor(named: "mainTextBlack")
        answerLabel.numberOfLines = 1

        contentView.addSubview(containerView)
        containerView.addSubview(answerLabel)

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
            $0.height.equalTo(52)
        }

        answerLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }

    func configure(text: String, isSelected: Bool) {
        answerLabel.text = text
        updateSelection(isSelected: isSelected)
    }

    private func updateSelection(isSelected: Bool) {
        if isSelected {
            containerView.backgroundColor = UIColor(named: "selectedCellGreen") ?? .systemGreen
            answerLabel.textColor = .white
        } else {
            containerView.backgroundColor = .white
            answerLabel.textColor = UIColor(named: "mainTextBlack")
        }
    }
}

