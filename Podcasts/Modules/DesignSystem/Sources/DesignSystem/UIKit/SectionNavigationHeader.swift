//
//  SectionNavigationHeader.swift
//  Common
//
//  Created by Noor El-Din Walid on 20/08/2025.
//

import UIKit
import Common

public final class SectionNavigationHeader: UIView {
    public enum LanguageDirection {
        case leftToRight
        case rightToLeft
        
        var isRTL: Bool {
            return self == .rightToLeft
        }
    }
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CustomFonts.title3UI
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private var backButtonLeadingConstraint: NSLayoutConstraint!
    private var backButtonTrailingConstraint: NSLayoutConstraint!
    public var onBackTapped: (() -> Void)?
    
    public var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    public var showBackButton: Bool = true {
        didSet {
            backButton.isHidden = !showBackButton
        }
    }
    
    public var languageDirection: LanguageDirection = .leftToRight {
        didSet {
            updateLayoutForLanguage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public convenience init(
        title: String,
        showBackButton: Bool = true,
        languageDirection: LanguageDirection = .leftToRight
    ) {
        self.init(frame: .zero)
        self.title = title
        self.showBackButton = showBackButton
        self.languageDirection = languageDirection
        self.titleLabel.text = title
        self.backButton.isHidden = !showBackButton
        updateLayoutForLanguage()
    }
    
    private func setupUI() {
        backgroundColor = .black
        
        addSubview(titleLabel)
        addSubview(backButton)
        
        setupConstraints()
        setupActions()
        updateLayoutForLanguage()
    }
    
    private func setupConstraints() {
        // Back button constraints for both Arabic and English versions
        backButtonLeadingConstraint = backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        backButtonTrailingConstraint = backButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 35),
            backButton.heightAnchor.constraint(equalToConstant: 35),
            
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            
            heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func updateLayoutForLanguage() {
        backButtonLeadingConstraint.isActive = false
        backButtonTrailingConstraint.isActive = false
        
        let chevronDirection = languageDirection.isRTL ? "chevron.left" : "chevron.right"
        let image = UIImage(systemName: chevronDirection)?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
        backButton.setImage(image, for: .normal)
        
        if languageDirection.isRTL {
            backButtonLeadingConstraint.isActive = true
        } else {
            backButtonTrailingConstraint.isActive = true
        }
        
        semanticContentAttribute = languageDirection.isRTL ? .forceRightToLeft : .forceLeftToRight
        backButton.semanticContentAttribute = semanticContentAttribute
        titleLabel.semanticContentAttribute = semanticContentAttribute
    }
    
    @objc private func backButtonTapped() {
        onBackTapped?()
    }
}
