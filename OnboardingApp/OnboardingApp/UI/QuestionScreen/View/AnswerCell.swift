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

    // MARK: - UI
    
    private let vContainer: UIView = UIView()
    private let lbAnswer: UILabel = UILabel()

    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        layoutUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        vContainer.layer.cornerRadius = 16
        vContainer.clipsToBounds = true
        vContainer.backgroundColor = .white

        lbAnswer.font = Theme.Fonts.body(weight: .medium)
        lbAnswer.textColor = Theme.Colors.mainTextBlack
        lbAnswer.numberOfLines = 1
    }
    
    private func layoutUI() {
        contentView.addSubview(vContainer)
        vContainer.addSubview(lbAnswer)

        vContainer.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0))
            $0.height.equalTo(52)
        }

        lbAnswer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }

    private func updateSelection(isSelected: Bool) {
        if isSelected {
            vContainer.backgroundColor = Theme.Colors.selectedCellGreen
            lbAnswer.textColor = .white
        } else {
            vContainer.backgroundColor = .white
            lbAnswer.textColor = Theme.Colors.mainTextBlack
        }
    }
    
    // MARK: - Public
    
    func configure(text: String, isSelected: Bool) {
        lbAnswer.text = text
        updateSelection(isSelected: isSelected)
    }
}
