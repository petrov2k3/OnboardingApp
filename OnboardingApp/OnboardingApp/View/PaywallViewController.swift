//
//  PaywallViewController.swift
//  OnboardingApp
//
//  Created by Ivan Petrov on 03.11.2025.
//

import UIKit
import SnapKit
import SafariServices

protocol PaywallViewControllerProtocol: AnyObject {
    func updatePriceText(_ priceText: String)
    func setLoading(_ isLoading: Bool)
    func setPurchaseButtonEnabled(_ isEnabled: Bool)
    func showError(message: String)
}

final class PaywallViewController: UIViewController {

    // MARK: - UI
    
    private let ivOnboarding: UIImageView = UIImageView()
    private let btClose: UIButton = UIButton(type: .system)
    private let lbTitle: UILabel = UILabel()
    private let lbDescription: UILabel = UILabel()
    private let btBuy: UIButton = UIButton(type: .system)
    private let tvLegal: UITextView = UITextView()
    
    // MARK: - Properties
    
    private let presenter: PaywallPresenterProtocol
    
    // MARK: - Inits
    
    init(presenter: PaywallPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        layoutUI()
        
        setupLegalTextView()
        setupActions()
        
        presenter.viewDidLoad()
    }
    
    // MARK: - Private

    private func setupUI() {
        view.backgroundColor = Theme.Colors.mainBackgroundScreen
        
        ivOnboarding.image = Theme.Images.onboarding
        ivOnboarding.contentMode = .scaleAspectFill
        ivOnboarding.clipsToBounds = true
        
        btClose.setImage(Theme.Icons.close, for: .normal)
        
        lbTitle.text = "Discover all\nPremium features"
        lbTitle.font = Theme.Fonts.title()
        lbTitle.textColor = Theme.Colors.mainTextBlack
        lbTitle.textAlignment = .left
        lbTitle.numberOfLines = 0
        
        lbDescription.numberOfLines = 0
        lbDescription.textAlignment = .left
        
        btBuy.setTitle("Start Now", for: .normal)
        btBuy.titleLabel?.font = Theme.Fonts.body(17, weight: .semibold)
        btBuy.backgroundColor = Theme.Colors.buttonBackgroundBlack
        btBuy.setTitleColor(.white, for: .normal)
        btBuy.layer.cornerRadius = 28
        btBuy.clipsToBounds = true
        
        tvLegal.isEditable = false
        tvLegal.isScrollEnabled = false
        tvLegal.backgroundColor = .clear
    }
    
    private func layoutUI() {
        view.addSubviews(ivOnboarding, btClose, lbTitle, lbDescription, btBuy, tvLegal)
        
        ivOnboarding.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        
        btClose.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(24)
        }
        
        lbTitle.snp.makeConstraints {
            $0.top.equalTo(ivOnboarding.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        lbDescription.snp.makeConstraints {
            $0.top.equalTo(lbTitle.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        tvLegal.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
        }
        
        btBuy.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(tvLegal.snp.top).offset(-20)
            $0.height.equalTo(56)
        }
    }
    
    private func setupDescriptionLabel(priceText: String = "") {
        let priceText = priceText.isEmpty ? "$-" : priceText
        let fullText = "Try 7 days for free\nthen \(priceText) per week, auto-renewable"

        let attributed = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: Theme.Fonts.body(weight: .medium),
                .foregroundColor: Theme.Colors.descriptionTextGray
            ]
        )

        let priceRange = (fullText as NSString).range(of: priceText)
        
        if priceRange.location != NSNotFound {
            attributed.addAttributes([
                .font: Theme.Fonts.body(weight: .bold),
                .foregroundColor: Theme.Colors.mainTextBlack
            ], range: priceRange)
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 2
        
        attributed.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributed.length)
        )

        lbDescription.attributedText = attributed
    }

    private func setupLegalTextView() {
        let baseText = "By continuing you accept our:\nTerms of Use, Privacy Policy, Subscription Terms"

        let grayColor = Theme.Colors.descriptionTextGray
        let linkColor = Theme.Colors.linkTextBlue

        let font = Theme.Fonts.legal()

        let attributed = NSMutableAttributedString(
            string: baseText,
            attributes: [
                .font: font,
                .foregroundColor: grayColor
            ]
        )
        
        let links: [(String, String)] = [
            ("Terms of Use", "termsOfUse://"),
            ("Privacy Policy", "privacyPolicy://"),
            ("Subscription Terms", "subscriptionTerms://")
        ]
        
        links.forEach { (text, scheme) in
            let range = (baseText as NSString).range(of: text)
            if range.location != NSNotFound {
                attributed.addAttributes([
                    .foregroundColor: linkColor,
                    .link: scheme
                ], range: range)
            }
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 2
        
        attributed.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributed.length)
        )
        
        tvLegal.attributedText = attributed
        tvLegal.linkTextAttributes = [.foregroundColor: linkColor]
        tvLegal.textAlignment = .center
        tvLegal.delegate = self
    }
    
    private func setupActions() {
        btBuy.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        btClose.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    private func openLinkInsideApp(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let safariVC = SFSafariViewController(url: url)
        
        present(safariVC, animated: true)
    }

    // MARK: - Actions
    
    @objc
    private func buyButtonTapped() {
        presenter.didTapBuy()
    }
    
    @objc
    private func closeButtonTapped() {
        presenter.didTapClose()
    }
}

// MARK: - UITextViewDelegate

extension PaywallViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        switch URL.scheme {
        case "termsOfUse":
            openLinkInsideApp("https://www.apple.com/ipad-pro/")
            
        case "privacyPolicy":
            openLinkInsideApp("https://www.apple.com/iphone-air/")
            
        case "subscriptionTerms":
            openLinkInsideApp("https://www.apple.com/macbook-pro/")
            
        default:
            break
        }
        
        return false
    }
}

// MARK: - PaywallViewControllerProtocol

extension PaywallViewController: PaywallViewControllerProtocol {
    func updatePriceText(_ priceText: String) {
        setupDescriptionLabel(priceText: priceText)
    }

    func setLoading(_ isLoading: Bool) {
        btBuy.isEnabled = !isLoading
        // TODO: (maybe) add an activity indicator
    }

    func setPurchaseButtonEnabled(_ isEnabled: Bool) {
        btBuy.isEnabled = isEnabled
        btBuy.alpha = isEnabled ? 1.0 : 0.7
    }

    func showError(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
}
