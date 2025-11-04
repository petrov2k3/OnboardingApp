//
//  WelcomeViewController.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 03.11.2025.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {

    // MARK: - Properties
    
    private let lbTitle: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = "Welcome!"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        startOnboardingFlow()
    }

    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(lbTitle)

        lbTitle.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }

    private func startOnboardingFlow() {
        Task {
            let onboardingFlow: OnboardingFlow = OnboardingFlow()
            await onboardingFlow.run(from: self)
        }
    }
}
