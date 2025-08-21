//
//  SectionNavigationHeader.swift
//  Common
//
//  Created by Noor El-Din Walid on 20/08/2025.
//

import UIKit

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
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        return view
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
        addSubview(separatorLine)
        
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
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 60),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -60),
            
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5),
            
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
