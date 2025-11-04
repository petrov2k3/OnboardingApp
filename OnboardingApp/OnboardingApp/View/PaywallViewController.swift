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
    
    private let ivOnboarding: UIImageView = {
        let imageView: UIImageView = UIImageView()
        
        imageView.image = UIImage(named: "img_onboarding")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let btClose: UIButton = {
        let button: UIButton = UIButton(type: .system)
        
        let image = UIImage(named: "ic_cancel")
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let lbTitle: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = "Discover all\nPremium features"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor(named: "mainTextBlack")
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()

    private let lbDescription: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = "Try 7 days for free\nthen $6.99 per week, auto-renewable"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        label.textColor = UIColor(named: "descriptionTextGray")
        label.numberOfLines = 0
        
        return label
    }()

    private let btBuy: UIButton = {
        let button: UIButton = UIButton(type: .system)
        
        button.setTitle("Start Now", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = UIColor(named: "buttonBackgroundBlack")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 28
        button.clipsToBounds = true
        
        return button
    }()
    
    private let legalTextView: UITextView = {
        let textView: UITextView = UITextView()
        
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        
        return textView
    }()
    
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
        setupDescriptionLabel(priceText: "$6.99") // TODO: change with receiving from presenter
        setupLegalTextView()
        setupActions()
        
        presenter.viewDidLoad()
    }
    
    // MARK: - Private

    private func setupUI() {
        view.backgroundColor = UIColor(named: "mainBackgroundScreen")
        
        view.addSubviews(ivOnboarding, btClose, lbTitle, lbDescription, btBuy, legalTextView)
        
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
        
        legalTextView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
        }
        
        btBuy.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(legalTextView.snp.top).offset(-20)
            $0.height.equalTo(56)
        }
    }
    
    private func setupDescriptionLabel(priceText: String) {
        let fullText = "Try 7 days for free\nthen \(priceText) per week, auto-renewable"

        let grayColor = UIColor(named: "descriptionTextGray") ?? .gray
        let blackColor = UIColor(named: "mainTextBlack") ?? .black
        
        let fontRegular = UIFont.systemFont(ofSize: 16, weight: .medium)
        let fontBold = UIFont.systemFont(ofSize: 16, weight: .bold)

        let attributed = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: fontRegular,
                .foregroundColor: grayColor
            ]
        )

        let priceRange = (fullText as NSString).range(of: priceText)
        
        if priceRange.location != NSNotFound {
            attributed.addAttributes([
                .font: fontBold,
                .foregroundColor: blackColor
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

        let grayColor = UIColor(named: "descriptionTextGray") ?? .gray
        let linkColor = UIColor(named: "linkTextBlue") ?? .systemBlue

        let font = UIFont.systemFont(ofSize: 12, weight: .regular)

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
        
        legalTextView.attributedText = attributed
        legalTextView.linkTextAttributes = [.foregroundColor: linkColor]
        legalTextView.textAlignment = .center
        legalTextView.delegate = self
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

// MARK: - PaywallView

extension PaywallViewController: PaywallView {
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
