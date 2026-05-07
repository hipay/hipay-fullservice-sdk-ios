//
//  HiPayCardFieldsView.swift
//  HiPayFullservice
//
//  Created by HiPay on 07/04/2026.
//  Copyright (c) 2026 HiPay. All rights reserved.
//

import UIKit

// MARK: - HiPayTextFieldStyle

@objc public enum HiPayTextFieldStyle: Int {
    case standard
    case underlined
    case filled
    case outlined
}

// MARK: - Style Application

@MainActor private extension HiPayTextFieldStyle {
    func apply(to field: UITextField, backgroundColor: UIColor, borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat) {
        field.layer.sublayers?.removeAll { $0.name == "bottomLine" }
        field.leftView = nil
        field.leftViewMode = .never
        field.layer.maskedCorners = [
            .layerMinXMinYCorner, .layerMaxXMinYCorner,
            .layerMinXMaxYCorner, .layerMaxXMaxYCorner
        ]

        switch self {
        case .standard:
            field.borderStyle = .roundedRect
            field.backgroundColor = backgroundColor != .clear ? backgroundColor : nil
            field.layer.borderWidth = 0
            field.layer.cornerRadius = 0

        case .underlined:
            field.borderStyle = .none
            field.backgroundColor = backgroundColor != .clear ? backgroundColor : .clear
            field.layer.borderWidth = 0
            field.layer.cornerRadius = 0
            addBottomLine(to: field, color: borderColor, width: borderWidth)

        case .filled:
            field.borderStyle = .none
            field.backgroundColor = backgroundColor != .clear ? backgroundColor : UIColor(white: 0.95, alpha: 1.0)
            field.layer.cornerRadius = cornerRadius
            field.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            field.layer.borderWidth = 0
            addBottomLine(to: field, color: borderColor, width: borderWidth)
            addLeftPadding(to: field)

        case .outlined:
            field.borderStyle = .none
            field.backgroundColor = backgroundColor
            field.layer.borderColor = borderColor.cgColor
            field.layer.borderWidth = borderWidth
            field.layer.cornerRadius = cornerRadius
            addLeftPadding(to: field)
        }
    }

    private func addBottomLine(to field: UITextField, color: UIColor, width: CGFloat) {
        let line = CALayer()
        line.name = "bottomLine"
        line.backgroundColor = color.cgColor
        line.frame = CGRect(
            x: 0,
            y: field.bounds.height > 0 ? field.bounds.height - width : 30,
            width: field.bounds.width > 0 ? field.bounds.width : UIScreen.main.bounds.width,
            height: max(width, 1)
        )
        field.layer.addSublayer(line)
    }

    private func addLeftPadding(to field: UITextField, paddingWidth: CGFloat = 12) {
        let pad = UIView(frame: CGRect(x: 0, y: 0, width: paddingWidth, height: 1))
        field.leftView = pad
        field.leftViewMode = .always
    }
}

// MARK: - Error

public let HiPayCardFieldsErrorDomain = "com.hipay.sdk.cardfields"

@objc public enum HiPayCardFieldsErrorCode: Int {
    case incompleteFields = 1000
    case tokenizationFailed = 1001
}

// MARK: - Delegate

@objc public protocol HiPayCardFieldsViewDelegate: AnyObject {
    @objc optional func cardFieldsView(_ view: HiPayCardFieldsView, didChangeValidity isValid: Bool)
    @objc optional func cardFieldsView(_ view: HiPayCardFieldsView, didTokenize token: HPFPaymentCardToken)
    @objc optional func cardFieldsView(_ view: HiPayCardFieldsView, didFailWithError error: Error)
}

// MARK: - HiPayCardFieldsView

@objc public final class HiPayCardFieldsView: UIView {

    // MARK: - Private fields

    private let cardholderNameField = UITextField()
    private let cardNumberField = HPFCardNumberTextField()
    private let expiryDateField = HPFExpiryDateTextField()
    private let securityCodeField = HPFSecurityCodeTextField()

    private var allFields: [UITextField] {
        [cardholderNameField, cardNumberField, expiryDateField, securityCodeField]
    }

    // MARK: - Error Labels

    private let cardholderErrorLabel = UILabel()
    private let cardNumberErrorLabel = UILabel()
    private let expiryErrorLabel = UILabel()
    private let securityCodeErrorLabel = UILabel()

    private var allErrorLabels: [UILabel] {
        [cardholderErrorLabel, cardNumberErrorLabel, expiryErrorLabel, securityCodeErrorLabel]
    }

    private func errorLabel(for field: UITextField) -> UILabel {
        if field === cardholderNameField { return cardholderErrorLabel }
        if field === cardNumberField { return cardNumberErrorLabel }
        if field === expiryDateField { return expiryErrorLabel }
        return securityCodeErrorLabel
    }

    private func errorMessage(for field: UITextField) -> String {
        if field === cardholderNameField {
            return cardholderNameErrorMessage ?? Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_ERROR_CARDHOLDER")
        }
        if field === cardNumberField {
            return cardNumberErrorMessage ?? Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_ERROR_NUMBER")
        }
        if field === expiryDateField {
            return expiryDateErrorMessage ?? Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_ERROR_EXPIRY")
        }
        return securityCodeErrorMessage ?? Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_ERROR_CVC")
    }

    // MARK: - Layout

    private let mainStackView = UIStackView()
    private let bottomRowStack = UIStackView()

    // MARK: - Delegate & Callbacks

    @objc public weak var delegate: HiPayCardFieldsViewDelegate?
    @objc public var onValidityChange: ((Bool) -> Void)?

    var vaultClient: HPFSecureVaultClient = .shared()

    // MARK: - State

    @objc public var isValid: Bool {
        let nameValid = !isCardholderNameRequired
            || !(cardholderNameField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        return nameValid
            && cardNumberField.isCompleted
            && expiryDateField.isCompleted
            && securityCodeField.isCompleted
    }

    // MARK: - Token Options

    @objc public var cardholderName: String {
        get { cardholderNameField.text?.trimmingCharacters(in: .whitespaces) ?? "" }
        set { cardholderNameField.text = newValue }
    }

    @objc public var isCardholderNameRequired: Bool = true
    @objc public var multiUse: Bool = false

    // MARK: - Style

    @objc public var borderStyleType: HiPayTextFieldStyle = .outlined {
        didSet { applyStyle() }
    }

    // MARK: - Colors

    @objc public var inputColor: UIColor = .darkText {
        didSet { applyStyle() }
    }

    @objc public var placeholderColor: UIColor = .lightGray {
        didSet { applyStyle() }
    }

    @objc public var invalidColor: UIColor = .systemRed

    // MARK: - Container Styling

    @objc public var containerBorderColor: UIColor = .clear {
        didSet { layer.borderColor = containerBorderColor.cgColor }
    }

    @objc public var containerBorderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = containerBorderWidth }
    }

    @objc public var containerCornerRadius: CGFloat = 0 {
        didSet { layer.cornerRadius = containerCornerRadius }
    }

    // MARK: - Field Styling

    @objc public var fieldBackgroundColor: UIColor = .clear {
        didSet { applyStyle() }
    }

    @objc public var fieldBorderColor: UIColor = UIColor(white: 0.78, alpha: 1.0) {
        didSet { applyStyle() }
    }

    @objc public var fieldBorderWidth: CGFloat = 1.0 {
        didSet { applyStyle() }
    }

    @objc public var fieldCornerRadius: CGFloat = 8.0 {
        didSet { applyStyle() }
    }

    // MARK: - Spacing

    @objc public var fieldHeight: CGFloat = 44.0 {
        didSet { updateFieldHeights() }
    }

    @objc public var fieldsSpacing: CGFloat = 8.0 {
        didSet {
            mainStackView.spacing = fieldsSpacing
            bottomRowStack.spacing = fieldsSpacing
        }
    }

    // MARK: - Typography

    @objc public var fontFamily: String? { didSet { updateFont() } }
    @objc public var fontSize: CGFloat = 16.0 { didSet { updateFont() } }
    @objc public var fontWeight: String? { didSet { updateFont() } }
    @objc public var fontStyle: String? { didSet { updateFont() } }

    // MARK: - Placeholders

    @objc public lazy var cardholderNamePlaceholder: String = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_PLACEHOLDER_CARDHOLDER") {
        didSet { cardholderNameField.placeholder = cardholderNamePlaceholder; applyStyle() }
    }

    @objc public lazy var cardNumberPlaceholder: String = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_PLACEHOLDER_NUMBER") {
        didSet { cardNumberField.placeholder = cardNumberPlaceholder; applyStyle() }
    }

    @objc public lazy var expiryDatePlaceholder: String = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_PLACEHOLDER_EXPIRY") {
        didSet { expiryDateField.placeholder = expiryDatePlaceholder; applyStyle() }
    }

    @objc public lazy var securityCodePlaceholder: String = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_PLACEHOLDER_CVC") {
        didSet { securityCodeField.placeholder = securityCodePlaceholder; applyStyle() }
    }

    // MARK: - Error messages

    @objc public var cardholderNameErrorMessage: String?
    @objc public var cardNumberErrorMessage: String?
    @objc public var expiryDateErrorMessage: String?
    @objc public var securityCodeErrorMessage: String?

    // MARK: - Init

    @objc override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    @objc required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private var fieldHeightConstraints: [NSLayoutConstraint] = []

    private func commonInit() {
        setupFields()
        setupLayout()
        applyStyle()
        updateFont()
    }

    // MARK: - Setup

    private func setupFields() {
        cardholderNameField.placeholder = cardholderNamePlaceholder
        cardholderNameField.keyboardType = .default
        cardholderNameField.autocapitalizationType = .words
        cardholderNameField.autocorrectionType = .no
        cardholderNameField.returnKeyType = .next
        cardholderNameField.accessibilityLabel = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_A11Y_CARDHOLDER")
        cardholderNameField.delegate = self

        cardNumberField.placeholder = cardNumberPlaceholder
        expiryDateField.placeholder = expiryDatePlaceholder
        securityCodeField.placeholder = securityCodePlaceholder

        cardNumberField.keyboardType = .asciiCapableNumberPad
        expiryDateField.keyboardType = .asciiCapableNumberPad
        securityCodeField.keyboardType = .asciiCapableNumberPad

        cardNumberField.accessibilityLabel = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_A11Y_NUMBER")
        expiryDateField.accessibilityLabel = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_A11Y_EXPIRY")
        securityCodeField.accessibilityLabel = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_A11Y_CVC")

        for field in allFields {
            field.addTarget(self, action: #selector(fieldDidChange(_:)), for: .editingChanged)
            field.addTarget(self, action: #selector(fieldDidBeginEditing(_:)), for: .editingDidBegin)
            field.addTarget(self, action: #selector(fieldDidEndEditing(_:)), for: .editingDidEnd)
        }

        for label in allErrorLabels {
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = invalidColor
            label.isHidden = true
            label.numberOfLines = 1
        }
    }

    private func makeFieldGroup(field: UITextField, errorLabel: UILabel) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.addArrangedSubview(field)
        stack.addArrangedSubview(errorLabel)
        return stack
    }

    private func setupLayout() {
        let cardholderGroup = makeFieldGroup(field: cardholderNameField, errorLabel: cardholderErrorLabel)
        let cardNumberGroup = makeFieldGroup(field: cardNumberField, errorLabel: cardNumberErrorLabel)

        let expiryGroup = makeFieldGroup(field: expiryDateField, errorLabel: expiryErrorLabel)
        let securityGroup = makeFieldGroup(field: securityCodeField, errorLabel: securityCodeErrorLabel)

        bottomRowStack.axis = .horizontal
        bottomRowStack.spacing = fieldsSpacing
        bottomRowStack.distribution = .fillEqually
        bottomRowStack.addArrangedSubview(expiryGroup)
        bottomRowStack.addArrangedSubview(securityGroup)

        mainStackView.axis = .vertical
        mainStackView.spacing = fieldsSpacing
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(cardholderGroup)
        mainStackView.addArrangedSubview(cardNumberGroup)
        mainStackView.addArrangedSubview(bottomRowStack)

        addSubview(mainStackView)

        fieldHeightConstraints = allFields.map { field in
            field.heightAnchor.constraint(equalToConstant: fieldHeight)
        }

        NSLayoutConstraint.activate(fieldHeightConstraints)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func updateFieldHeights() {
        fieldHeightConstraints.forEach { $0.constant = fieldHeight }
    }

    // MARK: - Layout Updates

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard borderStyleType == .underlined || borderStyleType == .filled else { return }
        for field in allFields {
            field.layer.sublayers?
                .filter { $0.name == "bottomLine" }
                .forEach { line in
                    line.frame = CGRect(
                        x: 0,
                        y: field.bounds.height - fieldBorderWidth,
                        width: field.bounds.width,
                        height: fieldBorderWidth
                    )
                }
        }
    }

    // MARK: - Style

    private func applyStyle() {
        layer.borderColor = containerBorderColor.cgColor
        layer.borderWidth = containerBorderWidth
        layer.cornerRadius = containerCornerRadius
        clipsToBounds = true

        for field in allFields {
            field.textColor = inputColor
            borderStyleType.apply(
                to: field,
                backgroundColor: fieldBackgroundColor,
                borderColor: fieldBorderColor,
                borderWidth: fieldBorderWidth,
                cornerRadius: fieldCornerRadius
            )
            applyPlaceholder(to: field)
        }
    }

    private func applyPlaceholder(to field: UITextField) {
        guard let text = field.placeholder else { return }
        field.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [.foregroundColor: placeholderColor]
        )
    }

    // MARK: - Font

    private func updateFont() {
        let font = buildFont()
        allFields.forEach { $0.font = font }
    }

    private func buildFont() -> UIFont {
        let size = fontSize > 0 ? fontSize : 16.0
        let weight = resolvedFontWeight()

        var font: UIFont
        if let family = fontFamily, let namedFont = UIFont(name: family, size: size) {
            font = namedFont
        } else {
            font = UIFont.systemFont(ofSize: size, weight: weight)
        }

        if fontStyle?.lowercased() == "italic",
           let italicDescriptor = font.fontDescriptor.withSymbolicTraits(.traitItalic) {
            font = UIFont(descriptor: italicDescriptor, size: size)
        }

        return font
    }

    private func resolvedFontWeight() -> UIFont.Weight {
        switch fontWeight?.lowercased() {
        case "100", "ultralight":  return .ultraLight
        case "200", "thin":        return .thin
        case "300", "light":       return .light
        case "400", "regular":     return .regular
        case "500", "medium":      return .medium
        case "600", "semibold":    return .semibold
        case "700", "bold":        return .bold
        case "800", "heavy":       return .heavy
        case "900", "black":       return .black
        default:                   return .regular
        }
    }

    // MARK: - Field Events

    private var previousValidityState = false

    @objc private func fieldDidChange(_ sender: UITextField) {
        if sender === cardNumberField {
            if cardNumberField.paymentProductCodes.count == 1 {
                securityCodeField.paymentProductCode = (cardNumberField.paymentProductCodes as NSSet).anyObject() as? String
            } else {
                securityCodeField.paymentProductCode = nil
            }
        }

        let current = isValid
        if current != previousValidityState {
            previousValidityState = current
            delegate?.cardFieldsView?(self, didChangeValidity: current)
            onValidityChange?(current)
        }

        if sender === cardNumberField, cardNumberField.isCompleted {
            expiryDateField.becomeFirstResponder()
        } else if sender === expiryDateField, expiryDateField.isCompleted {
            securityCodeField.becomeFirstResponder()
        }
    }

    @objc private func fieldDidBeginEditing(_ sender: UITextField) {
        clearError(for: sender)
    }

    @objc private func fieldDidEndEditing(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else {
            clearError(for: sender)
            return
        }

        let complete: Bool
        if sender === cardholderNameField {
            complete = !isCardholderNameRequired || !text.trimmingCharacters(in: .whitespaces).isEmpty
        } else if sender === cardNumberField {
            complete = cardNumberField.isCompleted
        } else if sender === expiryDateField {
            complete = expiryDateField.isCompleted
        } else if sender === securityCodeField {
            complete = securityCodeField.isCompleted
        } else {
            return
        }

        if complete {
            clearError(for: sender)
        } else {
            showError(for: sender)
        }
    }

    private func showError(for field: UITextField) {
        field.textColor = invalidColor
        field.layer.borderColor = invalidColor.cgColor

        if borderStyleType == .underlined || borderStyleType == .filled {
            field.layer.sublayers?
                .filter { $0.name == "bottomLine" }
                .forEach { $0.backgroundColor = invalidColor.cgColor }
        }

        let label = errorLabel(for: field)
        label.text = errorMessage(for: field)
        label.isHidden = false
    }

    private func clearError(for field: UITextField) {
        field.textColor = inputColor
        field.layer.borderColor = fieldBorderColor.cgColor

        if borderStyleType == .underlined || borderStyleType == .filled {
            field.layer.sublayers?
                .filter { $0.name == "bottomLine" }
                .forEach { $0.backgroundColor = fieldBorderColor.cgColor }
        }

        errorLabel(for: field).isHidden = true
    }

    // MARK: - Public API

    @objc public func clear() {
        allFields.forEach { $0.text = "" }
        previousValidityState = false
        applyStyle()
    }

    @objc public func generateToken(completion: @escaping (HPFPaymentCardToken?, Error?) -> Void) {
        guard isValid else {
            let error = NSError(
                domain: HiPayCardFieldsErrorDomain,
                code: HiPayCardFieldsErrorCode.incompleteFields.rawValue,
                userInfo: [NSLocalizedDescriptionKey: Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_ERROR_INCOMPLETE_FIELDS")]
            )
            DispatchQueue.main.async { completion(nil, error) }
            return
        }

        let cardNumber = cardNumberField.text?.replacingOccurrences(of: " ", with: "") ?? ""

        var month = "", year = ""
        if let expiry = expiryDateField.text, expiry.count >= 5 {
            let parts = expiry.components(separatedBy: "/")
            if parts.count == 2 {
                month = parts[0].trimmingCharacters(in: .whitespaces)
                year = String(format: "20%02d", Int(parts[1].trimmingCharacters(in: .whitespaces)) ?? 0)
            }
        }

        guard !month.isEmpty, !year.isEmpty else {
            let error = NSError(
                domain: HiPayCardFieldsErrorDomain,
                code: HiPayCardFieldsErrorCode.incompleteFields.rawValue,
                userInfo: [NSLocalizedDescriptionKey: Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_ERROR_INCOMPLETE_FIELDS")]
            )
            DispatchQueue.main.async { completion(nil, error) }
            return
        }

        vaultClient.generateToken(
            withCardNumber: cardNumber,
            cardExpiryMonth: month,
            cardExpiryYear: year,
            cardHolder: cardholderName,
            securityCode: securityCodeField.text ?? "",
            multiUse: multiUse
        ) { [weak self] token, error in
            DispatchQueue.main.async {
                guard let self else { return }
                if let error {
                    self.delegate?.cardFieldsView?(self, didFailWithError: error)
                    completion(nil, error)
                } else if let token {
                    self.delegate?.cardFieldsView?(self, didTokenize: token)
                    completion(token, nil)
                } else {
                    let fallbackError = NSError(
                        domain: HiPayCardFieldsErrorDomain,
                        code: HiPayCardFieldsErrorCode.tokenizationFailed.rawValue,
                        userInfo: [NSLocalizedDescriptionKey: Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_ERROR_TOKENIZATION_FAILED")]
                    )
                    self.delegate?.cardFieldsView?(self, didFailWithError: fallbackError)
                    completion(nil, fallbackError)
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension HiPayCardFieldsView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === cardholderNameField {
            cardNumberField.becomeFirstResponder()
        }
        return false
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField === cardholderNameField else { return true }
        let updated = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        return updated.count <= 26
    }
}
