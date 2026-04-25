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

@MainActor private extension HiPayTextFieldStyle {

    func apply(
        to field: UITextField,
        backgroundColor: UIColor,
        borderColor: UIColor,
        borderWidth: CGFloat,
        cornerRadius: CGFloat
    ) {
        field.layer.sublayers?.removeAll { $0.name == "bottomLine" }
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
            field.backgroundColor = backgroundColor != .clear ? backgroundColor : .secondarySystemBackground
            field.layer.cornerRadius = cornerRadius
            field.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            field.layer.borderWidth = 0
            addBottomLine(to: field, color: borderColor, width: borderWidth)

        case .outlined:
            field.borderStyle = .none
            field.backgroundColor = backgroundColor
            field.layer.borderColor = borderColor.cgColor
            field.layer.borderWidth = borderWidth
            field.layer.cornerRadius = cornerRadius
        }
    }

    var needsLeftPadding: Bool {
        switch self {
        case .filled, .outlined: return true
        case .standard, .underlined: return false
        }
    }

    var hasBottomLine: Bool {
        switch self {
        case .underlined, .filled: return true
        case .standard, .outlined: return false
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
}

// MARK: - Errors

public let HiPayCardFieldsErrorDomain = "com.hipay.sdk.cardfields"

@objc public enum HiPayCardFieldsErrorCode: Int {
    case incompleteFields = 1000
    case tokenizationFailed = 1001
    case cardTypeNotAllowed = 1002
}

// MARK: - Delegate

@objc public protocol HiPayCardFieldsViewDelegate: AnyObject {
    @objc optional func cardFieldsView(_ view: HiPayCardFieldsView, didChangeValidity isValid: Bool)
    @objc optional func cardFieldsView(_ view: HiPayCardFieldsView, didTokenize token: HPFPaymentCardToken)
    @objc optional func cardFieldsView(_ view: HiPayCardFieldsView, didFailWithError error: Error)
    @objc optional func cardFieldsView(_ view: HiPayCardFieldsView, didDetectNetworks networks: [String])
    @objc optional func cardFieldsView(_ view: HiPayCardFieldsView, didSelectNetwork network: String)
    @objc optional func cardFieldsView(_ view: HiPayCardFieldsView, didCompleteTransaction transaction: HPFTransaction)
    @objc optional func cardFieldsView(_ view: HiPayCardFieldsView, didFailPaymentWithError error: Error)
}

// MARK: - HiPayCardFieldsView

@objc public final class HiPayCardFieldsView: UIView {

    // MARK: Fields

    private let cardholderNameField = UITextField()
    private let cardNumberField = HPFCardNumberTextField()
    private let expiryDateField = HPFExpiryDateTextField()
    private let securityCodeField = HPFSecurityCodeTextField()

    private var allFields: [UITextField] {
        [cardholderNameField, cardNumberField, expiryDateField, securityCodeField]
    }

    // MARK: Error labels

    private let cardholderErrorLabel = UILabel()
    private let cardNumberErrorLabel = UILabel()
    private let expiryErrorLabel = UILabel()
    private let securityCodeErrorLabel = UILabel()

    private var allErrorLabels: [UILabel] {
        [cardholderErrorLabel, cardNumberErrorLabel, expiryErrorLabel, securityCodeErrorLabel]
    }

    // MARK: Network selector

    private var networkSelectorView: HPFCardNetworkRightView!
    private let networkErrorLabel = UILabel()

    // MARK: CVC help

    private let cvcInfoButton = UIButton(type: .system)
    private let cvcHintLabel = UILabel()

    // MARK: Layout

    private let mainStackView = UIStackView()
    private let bottomRowStack = UIStackView()
    private var fieldHeightConstraints: [NSLayoutConstraint] = []

    // MARK: Delegate & callbacks

    @objc public weak var delegate: HiPayCardFieldsViewDelegate?
    @objc public var onValidityChange: ((Bool) -> Void)?

    var vaultClient: HPFSecureVaultClient = .shared()

    // MARK: Network detection state

    @objc public private(set) var selectedNetwork: String?
    @objc public private(set) var detectedNetworks: [String] = []
    private var availableNetworks: [String] = []
    private var userPickedNetwork = false

    @objc public var allowedPaymentProducts: [String] = []
    private var didFetchAllowedPaymentProducts = false

    private var lastLookupBin: String?
    private var paymentProductsRequest: (any HPFRequest)?
    private var paymentCompletion: ((HPFTransaction?, Error?) -> Void)?
    private var binLookupToken: String?
    private var binLookupRequestId: String?

    // MARK: Validation state

    private var previousValidityState = false

    @objc public var isValid: Bool {
        let nameValid = !isCardholderNameRequired
            || !(cardholderNameField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        return nameValid
            && cardNumberField.isCompleted
            && expiryDateField.isCompleted
            && expiryDateField.isValid
            && securityCodeField.isCompleted
    }

    // MARK: Token options

    @objc public var cardholderName: String {
        get { cardholderNameField.text?.trimmingCharacters(in: .whitespaces) ?? "" }
        set { cardholderNameField.text = newValue }
    }

    @objc public var isCardholderNameRequired: Bool = false
    @objc public var multiUse: Bool = false

    // MARK: Style

    @objc public var borderStyleType: HiPayTextFieldStyle = .outlined {
        didSet { applyStyle() }
    }

    // MARK: Colors

    @objc public var inputColor: UIColor = .label {
        didSet { applyStyle() }
    }

    @objc public var placeholderColor: UIColor = .placeholderText {
        didSet { applyStyle() }
    }

    @objc public var invalidColor: UIColor = .systemRed

    // MARK: Container styling

    @objc public var containerBorderColor: UIColor = .clear {
        didSet { layer.borderColor = containerBorderColor.cgColor }
    }

    @objc public var containerBorderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = containerBorderWidth }
    }

    @objc public var containerCornerRadius: CGFloat = 0 {
        didSet { layer.cornerRadius = containerCornerRadius }
    }

    // MARK: Field styling

    @objc public var fieldBackgroundColor: UIColor = .clear {
        didSet { applyStyle() }
    }

    @objc public var fieldBorderColor: UIColor = .separator {
        didSet { applyStyle() }
    }

    @objc public var fieldBorderWidth: CGFloat = 1.0 {
        didSet { applyStyle() }
    }

    @objc public var fieldCornerRadius: CGFloat = 8.0 {
        didSet { applyStyle() }
    }

    // MARK: Spacing

    @objc public var fieldHeight: CGFloat = 44.0 {
        didSet { updateFieldHeights() }
    }

    @objc public var fieldsSpacing: CGFloat = 8.0 {
        didSet {
            mainStackView.spacing = fieldsSpacing
            bottomRowStack.spacing = fieldsSpacing
        }
    }

    // MARK: Typography

    @objc public var fontFamily: String? { didSet { updateFont() } }
    @objc public var fontSize: CGFloat = 16.0 { didSet { updateFont() } }
    @objc public var fontWeight: String? { didSet { updateFont() } }
    @objc public var fontStyle: String? { didSet { updateFont() } }

    // MARK: Left icons

    @objc public var cardholderIcon: UIImage? { didSet { applyStyle() } }
    @objc public var cardNumberIcon: UIImage? { didSet { applyStyle() } }
    @objc public var expiryDateIcon: UIImage? { didSet { applyStyle() } }
    @objc public var securityCodeIcon: UIImage? { didSet { applyStyle() } }

    @objc public var iconTintColor: UIColor = .label { didSet { applyStyle() } }
    @objc public var iconSize: CGSize = CGSize(width: 20, height: 20) { didSet { applyStyle() } }

    // MARK: Error messages

    @objc public var cardholderNameErrorMessage: String?
    @objc public var cardNumberErrorMessage: String?
    @objc public var expiryDateErrorMessage: String?
    @objc public var securityCodeErrorMessage: String?
    @objc public var cardTypeNotAllowedMessage: String?
    @objc public var cvcHintMessage: String?

    // MARK: Placeholders

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

    // MARK: Init

    @objc override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    @objc required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setupFields()
        setupLayout()
        applyStyle()
        updateFont()
    }

    // MARK: Lifecycle

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard borderStyleType.hasBottomLine else { return }
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

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        applyStyle()
        allErrorLabels.forEach { $0.textColor = invalidColor }
        networkErrorLabel.textColor = invalidColor
        networkSelectorView?.configure(availableCodes: availableNetworks, selectedCode: selectedNetwork)
    }
}

// MARK: - Setup

private extension HiPayCardFieldsView {

    func setupFields() {
        configureCardholderField()
        configureCardNumberField()
        configureExpiryField()
        configureSecurityCodeField()
        wireUpFieldEvents()
        configureErrorLabels()
        configureNetworkSelector()
        configureCVCHelp()
    }

    func configureCardholderField() {
        cardholderNameField.placeholder = cardholderNamePlaceholder
        cardholderNameField.keyboardType = .default
        cardholderNameField.autocapitalizationType = .words
        cardholderNameField.autocorrectionType = .no
        cardholderNameField.returnKeyType = .next
        cardholderNameField.accessibilityLabel = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_A11Y_CARDHOLDER_LABEL")
        cardholderNameField.accessibilityHint = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_A11Y_CARDHOLDER_HINT")
        cardholderNameField.delegate = self
    }

    func configureCardNumberField() {
        cardNumberField.placeholder = cardNumberPlaceholder
        cardNumberField.textContentType = .creditCardNumber
        cardNumberField.keyboardType = .asciiCapableNumberPad
        cardNumberField.accessibilityLabel = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_A11Y_NUMBER_LABEL")
        cardNumberField.accessibilityHint = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_A11Y_NUMBER_HINT")
    }

    func configureExpiryField() {
        expiryDateField.placeholder = expiryDatePlaceholder
        expiryDateField.keyboardType = .asciiCapableNumberPad
        expiryDateField.accessibilityLabel = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_A11Y_EXPIRY_LABEL")
        expiryDateField.accessibilityHint = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_A11Y_EXPIRY_HINT")
    }

    func configureSecurityCodeField() {
        securityCodeField.placeholder = securityCodePlaceholder
        securityCodeField.keyboardType = .asciiCapableNumberPad
        securityCodeField.accessibilityLabel = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_A11Y_CVC_LABEL")
        securityCodeField.accessibilityHint = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_A11Y_CVC_HINT")
    }

    func wireUpFieldEvents() {
        for field in allFields {
            field.addTarget(self, action: #selector(fieldDidChange(_:)), for: .editingChanged)
            field.addTarget(self, action: #selector(fieldDidBeginEditing(_:)), for: .editingDidBegin)
            field.addTarget(self, action: #selector(fieldDidEndEditing(_:)), for: .editingDidEnd)
        }
    }

    func configureErrorLabels() {
        for label in allErrorLabels {
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = invalidColor
            label.isHidden = true
            label.numberOfLines = 1
        }
        networkErrorLabel.font = UIFont.systemFont(ofSize: 12)
        networkErrorLabel.textColor = invalidColor
        networkErrorLabel.isHidden = true
        networkErrorLabel.numberOfLines = 1
    }

    func configureNetworkSelector() {
        let selector = HPFCardNetworkRightView(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        selector.onSelect = { [weak self] code in
            self?.userDidSelectNetwork(code)
        }
        cardNumberField.rightView = selector
        cardNumberField.rightViewMode = .never
        networkSelectorView = selector
    }

    func configureCVCHelp() {
        let image = UIImage(systemName: "info.circle")
        cvcInfoButton.setImage(image, for: .normal)
        cvcInfoButton.tintColor = .secondaryLabel
        cvcInfoButton.frame = CGRect(x: 0, y: 0, width: 28, height: 22)
        cvcInfoButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 8)
        cvcInfoButton.accessibilityLabel = Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_A11Y_CVC_HELP")
        cvcInfoButton.addTarget(self, action: #selector(toggleCVCHint), for: .touchUpInside)

        securityCodeField.rightView = cvcInfoButton
        securityCodeField.rightViewMode = .always

        cvcHintLabel.font = UIFont.systemFont(ofSize: 12)
        cvcHintLabel.textColor = .secondaryLabel
        cvcHintLabel.numberOfLines = 0
        cvcHintLabel.isHidden = true
    }

    func setupLayout() {
        let cardholderGroup = makeFieldGroup(field: cardholderNameField, errorLabel: cardholderErrorLabel)

        let cardNumberGroup = UIStackView()
        cardNumberGroup.axis = .vertical
        cardNumberGroup.spacing = 2
        cardNumberGroup.addArrangedSubview(cardNumberField)
        cardNumberGroup.addArrangedSubview(cardNumberErrorLabel)
        cardNumberGroup.addArrangedSubview(networkErrorLabel)

        let expiryGroup = makeFieldGroup(field: expiryDateField, errorLabel: expiryErrorLabel)
        let securityGroup = makeFieldGroup(field: securityCodeField, errorLabel: securityCodeErrorLabel)

        bottomRowStack.axis = .horizontal
        bottomRowStack.spacing = fieldsSpacing
        bottomRowStack.distribution = .fillEqually
        bottomRowStack.alignment = .top
        bottomRowStack.addArrangedSubview(expiryGroup)
        bottomRowStack.addArrangedSubview(securityGroup)

        mainStackView.axis = .vertical
        mainStackView.spacing = fieldsSpacing
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(cardholderGroup)
        mainStackView.addArrangedSubview(cardNumberGroup)
        mainStackView.addArrangedSubview(bottomRowStack)
        mainStackView.addArrangedSubview(cvcHintLabel)

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

    func makeFieldGroup(field: UITextField, errorLabel: UILabel) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.addArrangedSubview(field)
        stack.addArrangedSubview(errorLabel)
        return stack
    }

    func updateFieldHeights() {
        fieldHeightConstraints.forEach { $0.constant = fieldHeight }
    }
}

// MARK: - Styling

private extension HiPayCardFieldsView {

    func applyStyle() {
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
            applyLeftView(to: field)
            applyPlaceholder(to: field)
        }

        if let networkSelectorView, cardNumberField.rightView !== networkSelectorView {
            cardNumberField.rightView = networkSelectorView
        }
    }

    func icon(for field: UITextField) -> UIImage? {
        if field === cardholderNameField { return cardholderIcon }
        if field === cardNumberField { return cardNumberIcon }
        if field === expiryDateField { return expiryDateIcon }
        return securityCodeIcon
    }

    func applyLeftView(to field: UITextField) {
        let needsPadding = borderStyleType.needsLeftPadding

        guard let image = icon(for: field) else {
            applyPaddingOnlyLeftView(to: field, padded: needsPadding)
            return
        }

        let leadingPad: CGFloat = needsPadding ? 12 : 8
        let trailingPad: CGFloat = 8
        let totalWidth = leadingPad + iconSize.width + trailingPad
        let totalHeight = max(iconSize.height, 1)

        let container = UIView(frame: CGRect(x: 0, y: 0, width: totalWidth, height: totalHeight))
        let imageView = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = iconTintColor
        imageView.frame = CGRect(x: leadingPad, y: 0, width: iconSize.width, height: iconSize.height)
        container.addSubview(imageView)

        field.leftView = container
        field.leftViewMode = .always
    }

    func applyPaddingOnlyLeftView(to field: UITextField, padded: Bool) {
        guard padded else {
            field.leftView = nil
            field.leftViewMode = .never
            return
        }
        let pad = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        field.leftView = pad
        field.leftViewMode = .always
    }

    func applyPlaceholder(to field: UITextField) {
        guard let text = field.placeholder else { return }
        field.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [.foregroundColor: placeholderColor]
        )
    }

    func updateFont() {
        let font = buildFont()
        allFields.forEach { $0.font = font }
    }

    func buildFont() -> UIFont {
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

    func resolvedFontWeight() -> UIFont.Weight {
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
}

// MARK: - Editing & validation

private extension HiPayCardFieldsView {

    @objc func fieldDidChange(_ sender: UITextField) {
        if sender === cardNumberField {
            handleCardNumberChange()
        }

        notifyValidityChangeIfNeeded()
        advanceFocusIfFieldComplete(sender)
    }

    @objc func fieldDidBeginEditing(_ sender: UITextField) {
        clearError(for: sender)
    }

    @objc func fieldDidEndEditing(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else {
            clearError(for: sender)
            return
        }

        if isFieldComplete(sender, text: text) {
            clearError(for: sender)
        } else {
            showError(for: sender)
        }
    }

    func notifyValidityChangeIfNeeded() {
        let current = isValid
        guard current != previousValidityState else { return }
        previousValidityState = current
        delegate?.cardFieldsView?(self, didChangeValidity: current)
        onValidityChange?(current)
    }

    func advanceFocusIfFieldComplete(_ sender: UITextField) {
        if sender === cardNumberField, cardNumberField.isCompleted {
            expiryDateField.becomeFirstResponder()
        } else if sender === expiryDateField, expiryDateField.isCompleted {
            securityCodeField.becomeFirstResponder()
        }
    }

    func isFieldComplete(_ field: UITextField, text: String) -> Bool {
        if field === cardholderNameField {
            return !isCardholderNameRequired || !text.trimmingCharacters(in: .whitespaces).isEmpty
        }
        if field === cardNumberField { return cardNumberField.isCompleted }
        if field === expiryDateField { return expiryDateField.isCompleted && expiryDateField.isValid }
        if field === securityCodeField { return securityCodeField.isCompleted }
        return true
    }

    func showError(for field: UITextField) {
        field.textColor = invalidColor
        field.layer.borderColor = invalidColor.cgColor
        recolorBottomLine(for: field, with: invalidColor)

        let label = errorLabel(for: field)
        label.text = errorMessage(for: field)
        UIAccessibility.post(notification: .announcement, argument: label.text)
        label.isHidden = false
    }

    func clearError(for field: UITextField) {
        field.textColor = inputColor
        field.layer.borderColor = fieldBorderColor.cgColor
        recolorBottomLine(for: field, with: fieldBorderColor)
        errorLabel(for: field).isHidden = true
    }

    func recolorBottomLine(for field: UITextField, with color: UIColor) {
        guard borderStyleType.hasBottomLine else { return }
        field.layer.sublayers?
            .filter { $0.name == "bottomLine" }
            .forEach { $0.backgroundColor = color.cgColor }
    }

    func errorLabel(for field: UITextField) -> UILabel {
        if field === cardholderNameField { return cardholderErrorLabel }
        if field === cardNumberField { return cardNumberErrorLabel }
        if field === expiryDateField { return expiryErrorLabel }
        return securityCodeErrorLabel
    }

    func errorMessage(for field: UITextField) -> String {
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
}

// MARK: - CVC requirement & help

private extension HiPayCardFieldsView {

    enum CVCRequirement {
        case required(maxLength: Int)
        case notRequired
    }

    static func cvcRequirement(for network: String?) -> CVCRequirement {
        guard let network, !network.isEmpty else { return .required(maxLength: 3) }
        let normalized = network.lowercased()
        if normalized == HPFPaymentProductCodeAmericanExpress.lowercased() {
            return .required(maxLength: 4)
        }
        if normalized == HPFPaymentProductCodeBCMC.lowercased() {
            return .notRequired
        }
        return .required(maxLength: 3)
    }

    func applyCVCRequirement() {
        switch Self.cvcRequirement(for: selectedNetwork) {
        case .notRequired:
            securityCodeField.paymentProductCode = nil
            securityCodeField.text = ""
            securityCodeField.isEnabled = false
            clearError(for: securityCodeField)
        case .required(let maxLength):
            securityCodeField.paymentProductCode = selectedNetwork
            securityCodeField.isEnabled = true
            if let text = securityCodeField.text, text.count > maxLength {
                securityCodeField.text = String(text.prefix(maxLength))
            }
        }
        notifyValidityChangeIfNeeded()
    }

    @objc func toggleCVCHint() {
        if cvcHintLabel.text == nil || cvcHintLabel.text?.isEmpty == true {
            cvcHintLabel.text = cvcHintMessage ?? Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_HINT_CVC_HELP")
        }
        cvcHintLabel.isHidden.toggle()
    }
}

// MARK: - Network detection

private extension HiPayCardFieldsView {

    static let minDigitsForNetworkDetection = 2

    func handleCardNumberChange() {
        let cardNumber = cardNumberField.text ?? ""
        let cleanNumber = cardNumber.replacingOccurrences(of: " ", with: "")

        guard cleanNumber.count >= Self.minDigitsForNetworkDetection else {
            resetForUnknownCard()
            return
        }

        let rawDetected = Set(cardNumberField.paymentProductCodes.compactMap { $0 as? String })
        let detected = filterDetectedByCurrentLength(rawDetected, plainText: cleanNumber)

        guard !detected.isEmpty else {
            resetForUnknownCard()
            return
        }

        applyDetectedNetworks(detected, cardNumber: cardNumber)

        guard cardNumberField.isCompleted, cleanNumber != lastLookupBin else { return }
        performBinLookup(for: cleanNumber, cardNumber: cardNumber)
    }

    func resetForUnknownCard() {
        resetNetworkSelection()
        lastLookupBin = nil
        binLookupToken = nil
        binLookupRequestId = nil
        applyCVCRequirement()
    }

    func performBinLookup(for cleanNumber: String, cardNumber: String) {
        lastLookupBin = cleanNumber

        BinLookupService.shared.lookupWithBin(cleanNumber) { [weak self] (response: CardInfoResponse?, error: NSError?) in
            guard let self else { return }
            guard error == nil, let response else { return }

            let binNetworks = Set(response.allAvailableNetworks)
            DispatchQueue.main.async {
                self.binLookupToken = response.token
                self.binLookupRequestId = response.requestId
                self.applyDetectedNetworks(binNetworks, cardNumber: cardNumber)
            }
        }
    }

    func filterDetectedByCurrentLength(_ detected: Set<String>, plainText: String) -> Set<String> {
        guard let formatter = HPFCardNumberFormatter.shared() else { return detected }
        return detected.filter { code in
            let validLength = formatter.plainTextNumber(plainText, hasValidLengthForPaymentProductCode: code)
            let reachedMax = formatter.plainTextNumber(plainText, reachesMaxLengthForPaymentProductCode: code)
            return validLength || !reachedMax
        }
    }

    func applyDetectedNetworks(_ detected: Set<String>, cardNumber: String) {
        let allowed: Set<String>? = didFetchAllowedPaymentProducts
            ? Set(allowedPaymentProducts)
            : (allowedPaymentProducts.isEmpty ? nil : Set(allowedPaymentProducts))
        let sorted = HPFCardSchemeCoordinator.shared.getAvailableNetworks(
            forDetectedCodes: detected,
            cardNumber: cardNumber,
            allowedPaymentProductCodes: allowed
        )

        detectedNetworks = Array(detected)
        delegate?.cardFieldsView?(self, didDetectNetworks: detectedNetworks)

        if sorted.isEmpty {
            availableNetworks = []
            selectedNetwork = nil
            applyCVCRequirement()
            showNetworkError()
            return
        }

        clearNetworkError()
        availableNetworks = sorted

        let keepCurrent = userPickedNetwork
            && selectedNetwork.map { sorted.contains($0) } == true
        if !keepCurrent {
            selectedNetwork = sorted.first
        }

        applyCVCRequirement()
        updateNetworkSelectorUI()

        if let network = selectedNetwork {
            delegate?.cardFieldsView?(self, didSelectNetwork: network)
        }
    }

    func userDidSelectNetwork(_ code: String) {
        guard availableNetworks.contains(code) else { return }
        userPickedNetwork = true
        selectedNetwork = code
        applyCVCRequirement()
        updateNetworkSelectorUI()
        delegate?.cardFieldsView?(self, didSelectNetwork: code)
    }

    func resetNetworkSelection() {
        detectedNetworks = []
        availableNetworks = []
        selectedNetwork = nil
        userPickedNetwork = false
        lastLookupBin = nil
        clearNetworkError()
        hideNetworkSelector()
    }

    func hideNetworkSelector() {
        guard let networkSelectorView else { return }
        cardNumberField.rightViewMode = .never
        networkSelectorView.configure(availableCodes: [], selectedCode: nil)
    }

    func updateNetworkSelectorUI() {
        guard !availableNetworks.isEmpty else {
            hideNetworkSelector()
            return
        }
        cardNumberField.rightViewMode = .always
        networkSelectorView.configure(availableCodes: availableNetworks, selectedCode: selectedNetwork)
        networkSelectorView.invalidateIntrinsicContentSize()
        cardNumberField.setNeedsLayout()
    }

    func showNetworkError() {
        networkErrorLabel.text = cardTypeNotAllowedMessage ?? Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_ERROR_CARD_TYPE_NOT_ALLOWED")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // 1 second delay to let customer hear the number before the error
            UIAccessibility.post(notification: .announcement, argument: self.networkErrorLabel.text)
        }
        networkErrorLabel.isHidden = false
        hideNetworkSelector()
    }

    func clearNetworkError() {
        networkErrorLabel.isHidden = true
    }
}

// MARK: - Public API

public extension HiPayCardFieldsView {

    @objc func fetchAvailablePaymentProducts(
        currency: String,
        completion: ((Error?) -> Void)? = nil
    ) {
        paymentProductsRequest?.cancel()
        let request = HPFPaymentPageRequest()
        request.amount = 0
        request.currency = currency

        let handler = { [weak self] (products: [HPFPaymentProduct], error: Error?) -> Void in
            guard let self else { return }
            if let error {
                DispatchQueue.main.async { completion?(error) }
                return
            }

            let knownCardCodes = Self.knownCardPaymentProductCodes()
            let cardCodes = products.map { $0.code }.filter { knownCardCodes.contains($0) }

            DispatchQueue.main.async {
                self.allowedPaymentProducts = cardCodes
                self.didFetchAllowedPaymentProducts = true
                completion?(nil)
            }
        }
        paymentProductsRequest = HPFGatewayClient.shared()
            .getPaymentProducts(for: request, withCompletionHandler: handler)
    }

    @objc func clear() {
        allFields.forEach { $0.text = "" }
        previousValidityState = false
        resetNetworkSelection()
        applyStyle()
    }

    @objc func generateToken(completion: @escaping (HPFPaymentCardToken?, Error?) -> Void) {
        guard isValid, let expiry = parsedExpiry() else {
            DispatchQueue.main.async { completion(nil, Self.incompleteFieldsError()) }
            return
        }

        let cardNumber = cardNumberField.text?.replacingOccurrences(of: " ", with: "") ?? ""

        vaultClient.generateToken(
            withCardNumber: cardNumber,
            cardExpiryMonth: expiry.month,
            cardExpiryYear: expiry.year,
            cardHolder: cardholderName,
            securityCode: securityCodeField.text ?? "",
            multiUse: multiUse
        ) { [weak self] token, error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.handleTokenResult(token: token, error: error, completion: completion)
            }
        }
    }

    @objc func pay(
        orderRequest: HPFOrderRequest,
        signature: String,
        completion: ((HPFTransaction?, Error?) -> Void)? = nil
    ) {
        pay(
            orderRequest: orderRequest,
            signature: signature,
            eci: .HPFECISecureECommerce,
            authenticationIndicator: .ifAvailable,
            completion: completion
        )
    }

    @objc func pay(
        orderRequest: HPFOrderRequest,
        signature: String,
        eci: HPFECI,
        authenticationIndicator: HPFAuthenticationIndicator,
        completion: ((HPFTransaction?, Error?) -> Void)? = nil
    ) {
        paymentCompletion = completion

        acquirePaymentToken { [weak self] token, error in
            guard let self else { return }

            if let error {
                self.finishPayment(transaction: nil, error: error)
                return
            }

            guard let token else {
                self.finishPayment(transaction: nil, error: Self.tokenizationFailedError())
                return
            }

            self.submitOrder(
                orderRequest: orderRequest,
                signature: signature,
                token: token,
                eci: eci,
                authenticationIndicator: authenticationIndicator
            )
        }
    }
}

// MARK: - Tokenization & payment

private extension HiPayCardFieldsView {

    static func incompleteFieldsError() -> NSError {
        NSError(
            domain: HiPayCardFieldsErrorDomain,
            code: HiPayCardFieldsErrorCode.incompleteFields.rawValue,
            userInfo: [NSLocalizedDescriptionKey: Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_ERROR_INCOMPLETE_FIELDS")]
        )
    }

    static func tokenizationFailedError() -> NSError {
        NSError(
            domain: HiPayCardFieldsErrorDomain,
            code: HiPayCardFieldsErrorCode.tokenizationFailed.rawValue,
            userInfo: [NSLocalizedDescriptionKey: Bundle.hipayPaymentScreenLocalizedString(forKey: "HPF_CARD_FIELDS_ERROR_TOKENIZATION_FAILED")]
        )
    }

    static func knownCardPaymentProductCodes() -> Set<String> {
        guard
            let formatter = HPFCardNumberFormatter.shared(),
            let info = formatter.value(forKey: "paymentProductsInfo") as? [String: Any]
        else {
            return []
        }
        return Set(info.keys)
    }

    func parsedExpiry() -> (month: String, year: String)? {
        guard let text = expiryDateField.text, text.count >= 5 else { return nil }
        let parts = text.components(separatedBy: "/")
        guard parts.count == 2 else { return nil }
        let month = parts[0].trimmingCharacters(in: .whitespaces)
        let year = String(format: "20%02d", Int(parts[1].trimmingCharacters(in: .whitespaces)) ?? 0)
        guard !month.isEmpty else { return nil }
        return (month, year)
    }

    func acquirePaymentToken(completion: @escaping (HPFPaymentCardToken?, Error?) -> Void) {
        guard isValid, let expiry = parsedExpiry() else {
            DispatchQueue.main.async { completion(nil, Self.incompleteFieldsError()) }
            return
        }

        guard let token = binLookupToken, let requestId = binLookupRequestId else {
            generateToken(completion: completion)
            return
        }

        let cvc = securityCodeField.text ?? ""

        vaultClient.updatePaymentCard(
            withToken: token,
            requestID: requestId,
            setCardExpiryMonth: expiry.month,
            cardExpiryYear: expiry.year,
            cardHolder: cardholderName,
            securityCode: cvc
        ) { [weak self] updated, error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.handleTokenResult(token: updated, error: error, completion: completion)
            }
        }
    }

    func handleTokenResult(
        token: HPFPaymentCardToken?,
        error: Error?,
        completion: @escaping (HPFPaymentCardToken?, Error?) -> Void
    ) {
        if let error {
            delegate?.cardFieldsView?(self, didFailWithError: error)
            completion(nil, error)
            return
        }

        if let token {
            delegate?.cardFieldsView?(self, didTokenize: token)
            completion(token, nil)
            return
        }

        let fallbackError = Self.tokenizationFailedError()
        delegate?.cardFieldsView?(self, didFailWithError: fallbackError)
        completion(nil, fallbackError)
    }

    func submitOrder(
        orderRequest: HPFOrderRequest,
        signature: String,
        token: HPFPaymentCardToken,
        eci: HPFECI,
        authenticationIndicator: HPFAuthenticationIndicator
    ) {
        orderRequest.paymentProductCode = resolvePaymentProductCode(for: token)
        orderRequest.paymentMethod = HPFCardTokenPaymentMethodRequest(
            token: token.token,
            eci: eci,
            authenticationIndicator: authenticationIndicator
        )

        if multiUse {
            orderRequest.oneClick = true
        }

        HPFGatewayClient.shared().requestNewOrder(
            orderRequest,
            signature: signature
        ) { [weak self] transaction, error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.finishPayment(transaction: transaction, error: error)
            }
        }
    }

    func resolvePaymentProductCode(for token: HPFPaymentCardToken) -> String {
        let raw: String
        if let userSelected = selectedNetwork, !userSelected.isEmpty {
            raw = userSelected
        } else if let domestic = token.domesticNetwork, !domestic.isEmpty {
            raw = domestic
        } else {
            raw = token.brand
        }
        return raw
            .replacingOccurrences(of: " ", with: "-")
            .lowercased()
    }

    func finishPayment(transaction: HPFTransaction?, error: Error?) {
        let completion = paymentCompletion
        paymentCompletion = nil

        if let error {
            delegate?.cardFieldsView?(self, didFailPaymentWithError: error)
        } else if let transaction {
            delegate?.cardFieldsView?(self, didCompleteTransaction: transaction)
        }
        completion?(transaction, error)
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
