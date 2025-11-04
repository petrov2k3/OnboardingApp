//
//  PaywallViewController.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 03.11.2025.
//

import UIKit
import SnapKit
import SafariServices

final class PaywallViewController: UIViewController {

    // MARK: - UI
    
    private let lbTitle: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = "Discover all\nPremium features"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()

    private let lbDescription: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = "Try 7 days for free\nthen $6.99 per week, auto-renewable"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        
        return label
    }()

    private let btBuy: UIButton = {
        let button: UIButton = UIButton(type: .system)
        
        button.setTitle("Start Now", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 24
        
        return button
    }()
    
    // MARK: - Properties
    
    private let onClose: EmptyClosure
    
    // MARK: - Inits

    init(onClose: @escaping EmptyClosure) {
        self.onClose = onClose
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubviews(lbTitle, lbDescription, btBuy)
        
        lbTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        lbDescription.snp.makeConstraints {
            $0.top.equalTo(lbTitle.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        btBuy.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
            $0.width.equalTo(250)
            $0.height.equalTo(50)
        }
        
        btBuy.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions
    
    @objc
    private func buyButtonTapped() {
        onClose()
    }
}
