//
//  HPFAliasRowView.swift
//  HiPayFullservice
//
//  Created by Said EL MANSOUR on 25/04/2026.
//  Copyright © 2026 HiPay. All rights reserved.
//

import UIKit

final class HPFAliasRowView: UIView {

    let alias: HPFPaymentCardToken

    var isSelected: Bool = false {
        didSet { updateCheckbox() }
    }

    var onSelect: (() -> Void)?
    var onDelete: (() -> Void)?

    private let contentContainer = UIView()
    private let deleteOverlay = UIView()
    private let deleteIconView = UIImageView()
    private let checkboxImageView = UIImageView()
    private let brandImageView = UIImageView()
    private let panLabel = UILabel()
    private let cardholderLabel = UILabel()
    private let expiryLabel = UILabel()

    private static let deleteRevealWidth: CGFloat = 88
    private static let deleteRevealThreshold: CGFloat = 44
    private var contentTranslationX: CGFloat = 0
    private var isDeleteRevealed = false

    init(alias: HPFPaymentCardToken) {
        self.alias = alias
        super.init(frame: .zero)
        setupViews()
        setupLayout()
        setupGestures()
        bindData()
        updateCheckbox()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func setupViews() {
        backgroundColor = .clear
        clipsToBounds = true

        deleteOverlay.backgroundColor = .systemRed
        deleteOverlay.layer.cornerRadius = 6
        deleteOverlay.translatesAutoresizingMaskIntoConstraints = false

        deleteIconView.image = UIImage(systemName: "trash")
        deleteIconView.tintColor = .white
        deleteIconView.contentMode = .scaleAspectFit
        deleteIconView.translatesAutoresizingMaskIntoConstraints = false

        contentContainer.backgroundColor = .secondarySystemBackground
        contentContainer.layer.cornerRadius = 6
        contentContainer.translatesAutoresizingMaskIntoConstraints = false

        checkboxImageView.tintColor = .label
        checkboxImageView.contentMode = .scaleAspectFit
        checkboxImageView.setContentHuggingPriority(.required, for: .horizontal)

        brandImageView.contentMode = .scaleAspectFit
        brandImageView.setContentHuggingPriority(.required, for: .horizontal)
        brandImageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        panLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        panLabel.textColor = .label

        cardholderLabel.font = UIFont.systemFont(ofSize: 13)
        cardholderLabel.textColor = .secondaryLabel
        cardholderLabel.lineBreakMode = .byTruncatingTail
        cardholderLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        expiryLabel.font = UIFont.systemFont(ofSize: 13)
        expiryLabel.textColor = .secondaryLabel
        expiryLabel.setContentHuggingPriority(.required, for: .horizontal)
        expiryLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    private func setupLayout() {
        addSubview(deleteOverlay)
        deleteOverlay.addSubview(deleteIconView)
        addSubview(contentContainer)

        let infoBottomRow = UIStackView(arrangedSubviews: [cardholderLabel, expiryLabel])
        infoBottomRow.axis = .horizontal
        infoBottomRow.spacing = 8
        infoBottomRow.alignment = .firstBaseline

        let infoStack = UIStackView(arrangedSubviews: [panLabel, infoBottomRow])
        infoStack.axis = .vertical
        infoStack.spacing = 2

        let row = UIStackView(arrangedSubviews: [checkboxImageView, brandImageView, infoStack])
        row.axis = .horizontal
        row.spacing = 12
        row.alignment = .center
        row.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(row)

        NSLayoutConstraint.activate([
            deleteOverlay.topAnchor.constraint(equalTo: topAnchor),
            deleteOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            deleteOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            deleteOverlay.widthAnchor.constraint(equalToConstant: Self.deleteRevealWidth),

            deleteIconView.centerXAnchor.constraint(equalTo: deleteOverlay.centerXAnchor),
            deleteIconView.centerYAnchor.constraint(equalTo: deleteOverlay.centerYAnchor),
            deleteIconView.widthAnchor.constraint(equalToConstant: 22),
            deleteIconView.heightAnchor.constraint(equalToConstant: 22),

            contentContainer.topAnchor.constraint(equalTo: topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor),

            row.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 10),
            row.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -10),
            row.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 12),
            row.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -12),

            checkboxImageView.widthAnchor.constraint(equalToConstant: 24),
            checkboxImageView.heightAnchor.constraint(equalToConstant: 24),
            brandImageView.widthAnchor.constraint(equalToConstant: 32),
            brandImageView.heightAnchor.constraint(equalToConstant: 22)
        ])
    }

    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(contentTapped))
        contentContainer.addGestureRecognizer(tap)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(contentPanned(_:)))
        pan.delegate = self
        contentContainer.addGestureRecognizer(pan)

        let deleteTap = UITapGestureRecognizer(target: self, action: #selector(deleteTapped))
        deleteOverlay.addGestureRecognizer(deleteTap)

        contentContainer.isUserInteractionEnabled = true
        deleteOverlay.isUserInteractionEnabled = true

        accessibilityElements = [contentContainer, deleteOverlay]
        contentContainer.isAccessibilityElement = true
        contentContainer.accessibilityTraits = .button
        contentContainer.accessibilityLabel = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_A11Y_SELECT_SAVED_CARD")
        deleteOverlay.isAccessibilityElement = true
        deleteOverlay.accessibilityTraits = .button
        deleteOverlay.accessibilityLabel = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_A11Y_DELETE_SAVED_CARD")
    }

    private func bindData() {
        let brand = alias.value(forKey: "brand") as? String
        let pan = alias.value(forKey: "pan") as? String ?? ""
        let cardHolder = alias.value(forKey: "cardHolder") as? String ?? ""
        let month = (alias.value(forKey: "cardExpiryMonth") as? NSNumber)?.intValue ?? 0
        let year = (alias.value(forKey: "cardExpiryYear") as? NSNumber)?.intValue ?? 0
        brandImageView.image = UIImage.hipayBrandImage(for: brand)
        panLabel.text = Self.maskedPan(from: pan)
        cardholderLabel.text = cardHolder.uppercased()
        expiryLabel.text = String(format: "%02d / %04d", month, year)
    }

    private func updateCheckbox() {
        let symbol = isSelected ? "checkmark.square.fill" : "square"
        checkboxImageView.image = UIImage(systemName: symbol)
        let key = isSelected ? "HPF_CARD_FIELDS_A11Y_SELECTED" : "HPF_CARD_FIELDS_A11Y_NOT_SELECTED"
        contentContainer.accessibilityValue = Bundle.hipayPaymentScreenLocalizedString(forKey: key)

        contentContainer.layer.borderColor = isSelected ? UIColor.darkGray.cgColor : UIColor.clear.cgColor
        contentContainer.layer.borderWidth = isSelected ? 1 : 0
    }

    @objc private func contentTapped() {
        if isDeleteRevealed {
            setDeleteRevealed(false, animated: true)
            return
        }
        onSelect?()
    }

    @objc private func contentPanned(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self).x
        switch recognizer.state {
        case .began:
            contentTranslationX = isDeleteRevealed ? -Self.deleteRevealWidth : 0
        case .changed:
            let proposed = contentTranslationX + translation
            let clamped = min(0, max(-Self.deleteRevealWidth, proposed))
            contentContainer.transform = CGAffineTransform(translationX: clamped, y: 0)
        case .ended, .cancelled:
            let finalTranslation = contentTranslationX + translation
            let shouldReveal = finalTranslation < -Self.deleteRevealThreshold
            setDeleteRevealed(shouldReveal, animated: true)
        default:
            break
        }
    }

    @objc private func deleteTapped() {
        onDelete?()
    }

    private func setDeleteRevealed(_ revealed: Bool, animated: Bool) {
        isDeleteRevealed = revealed
        let target = revealed ? -Self.deleteRevealWidth : 0
        let apply = { self.contentContainer.transform = CGAffineTransform(translationX: target, y: 0) }
        guard animated else {
            apply()
            return
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: apply)
    }

    private static func maskedPan(from pan: String) -> String {
        let digitsOnly = pan.filter { $0.isNumber }
        let last4 = digitsOnly.suffix(4)
        return "---- ---- ---- \(last4)"
    }
}

extension HPFAliasRowView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        false
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        let velocity = pan.velocity(in: self)
        return abs(velocity.x) > abs(velocity.y)
    }
}
