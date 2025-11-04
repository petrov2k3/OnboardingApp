//
//  ButtonConfiguration.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 04.11.2025.
//

import UIKit

enum ButtonConfiguration {

    ///__ The main black button (like Start Now / active Continue)
    static func defaultBlack(title: String, font: UIFont = Theme.Fonts.body(17, weight: .semibold)) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = Theme.Colors.buttonBackgroundBlack
        configuration.baseForegroundColor = .white
        configuration.background.cornerRadius = 28
        
        configuration.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([
                .font: font
            ])
        )
        
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 18,
            leading: 24,
            bottom: 18,
            trailing: 24
        )
        
        return configuration
    }

    ///__ White button with gray text (inactive Continue)
    static func defaultWhite(title: String, font: UIFont = Theme.Fonts.body(17, weight: .semibold)) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = Theme.Colors.buttonTextGray
        configuration.background.cornerRadius = 28

        configuration.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([
                .font: font
            ])
        )

        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 18,
            leading: 24,
            bottom: 18,
            trailing: 24
        )

        return configuration
    }
}
