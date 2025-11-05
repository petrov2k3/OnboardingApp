//
//  UIView+Help.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 04.11.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}
