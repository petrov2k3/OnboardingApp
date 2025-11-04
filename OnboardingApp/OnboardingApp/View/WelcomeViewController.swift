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
    
    private let lbTitle: UILabel = UILabel()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        layoutUI()
        
        startOnboardingFlow()
    }

    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = Theme.Colors.mainBackgroundScreen

        lbTitle.text = "Welcome!"
        lbTitle.font = Theme.Fonts.title()
        lbTitle.textAlignment = .center
    }
    
    private func layoutUI() {
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
