//
//  Theme.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 04.11.2025.
//

import UIKit

enum Theme {

    enum Colors {
        static var mainBackgroundScreen: UIColor {
            UIColor(named: "mainBackgroundScreen") ?? .systemBackground
        }

        static var mainTextBlack: UIColor {
            UIColor(named: "mainTextBlack") ?? .label
        }

        static var descriptionTextGray: UIColor {
            UIColor(named: "descriptionTextGray") ?? .secondaryLabel
        }

        static var buttonBackgroundBlack: UIColor {
            UIColor(named: "buttonBackgroundBlack") ?? .black
        }

        static var buttonTextGray: UIColor {
            UIColor(named: "buttonTextGray") ?? .lightGray
        }

        static var linkTextBlue: UIColor {
            UIColor(named: "linkTextBlue") ?? .systemBlue
        }
    }

    enum Images {
        static var onboarding: UIImage? {
            UIImage(named: "img_onboarding")
        }
    }

    enum Icons {
        static var close: UIImage? {
            UIImage(named: "ic_cancel")
        }
    }

    enum Fonts {
        static func title(_ size: CGFloat = 32) -> UIFont {
            .systemFont(ofSize: size, weight: .bold)
        }

        static func subtitle(_ size: CGFloat = 20) -> UIFont {
            .systemFont(ofSize: size, weight: .semibold)
        }

        static func body(_ size: CGFloat = 16, weight: UIFont.Weight = .regular) -> UIFont {
            .systemFont(ofSize: size, weight: weight)
        }

        static func legal(_ size: CGFloat = 12) -> UIFont {
            .systemFont(ofSize: size, weight: .regular)
        }
    }
}
