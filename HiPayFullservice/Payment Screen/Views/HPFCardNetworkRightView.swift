//
//  HPFCardNetworkRightView.swift
//  Pods
//
//  Created by Mansour Said on 11/1/2026.
//

import UIKit

final class HPFCardNetworkRightView: UIView {

    private let stackView = UIStackView()
    private let leftPadding: CGFloat = 6
    private let rightPadding: CGFloat = 6
    private let spacing: CGFloat = 8

    var onSelect: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = true
        backgroundColor = .clear
        clipsToBounds = false

        stackView.axis = .horizontal
        stackView.spacing = spacing
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftPadding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -rightPadding),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(availableCodes: [String], selectedCode: String?) {
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        if availableCodes.isEmpty {
            invalidateIntrinsicContentSize()
            return
        }

        for code in availableCodes {
            let isSelected = (code == selectedCode)
            let itemView = createItemView(for: code, isSelected: isSelected)

            let tap = UITapGestureRecognizer(target: self, action: #selector(itemTapped(_:)))
            itemView.addGestureRecognizer(tap)
            itemView.isUserInteractionEnabled = true
            itemView.tag = code.hash
            itemView.accessibilityIdentifier = code

            stackView.addArrangedSubview(itemView)
        }

        invalidateIntrinsicContentSize()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    @objc private func itemTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view, let code = view.accessibilityIdentifier else { return }
        onSelect?(code)
    }
    
    private func createItemView(for code: String, isSelected: Bool) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let logoView = UIImageView()
        logoView.contentMode = .scaleAspectFit
        logoView.image = HPFCardSpriteProvider.logo(forPaymentProductCode: code, gray: false)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoView.widthAnchor.constraint(equalToConstant: 34),
            logoView.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        container.addSubview(logoView)
        
        NSLayoutConstraint.activate([
            logoView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4),
            logoView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4),
            logoView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            logoView.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor),
            logoView.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor)
        ])
        
        container.layer.cornerRadius = 4
        container.layer.borderWidth = 1
        
        if isSelected {
            container.layer.borderColor = UIColor.systemBlue.resolvedColor(with: container.traitCollection).cgColor
            container.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            container.alpha = 1.0
        } else {
            container.layer.borderColor = UIColor.separator.resolvedColor(with: container.traitCollection).cgColor
            container.backgroundColor = .clear
            container.alpha = 0.5
        }
        
        return container
    }

    override var intrinsicContentSize: CGSize {
        let size = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width + leftPadding + rightPadding, height: 32)
    }
}
