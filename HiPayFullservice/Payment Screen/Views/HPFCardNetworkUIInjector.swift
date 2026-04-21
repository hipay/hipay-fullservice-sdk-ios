//
//  HPFCardNetworkUIInjector.swift
//  Pods
//
//  Created by Mansour Said on 11/1/2026.
//

import UIKit

@objc public final class HPFCardNetworkUIInjector: NSObject {
    
    @objc nonisolated(unsafe) public static let shared = HPFCardNetworkUIInjector()
    
    private weak var handler: HPFCardNetworkSelectionHandling?
    private weak var textField: UITextField?
    private weak var presenter: UIViewController?
    
    private var rightView: HPFCardNetworkRightView?
    
    private var cachedNetworks: [String] = []
    private var cachedActive: String?
    private var cachedDetectedCodes: NSSet = []
    private var cachedCardNumber: String = ""
    
    @objc public func attach(
        to textField: UITextField,
        presenter: UIViewController,
        selectionHandler: HPFCardNetworkSelectionHandling
    ) {
        self.handler = selectionHandler
        self.textField = textField
        self.presenter = presenter
        
        if let existing = textField.rightView as? HPFCardNetworkRightView {
            
            existing.onSelect = { [weak self] code in self?.selectNetwork(code) }
            
            self.rightView = existing
            textField.rightViewMode = .never

            existing.configure(availableCodes: cachedNetworks, selectedCode: cachedActive)
            return
        }

        let rv = HPFCardNetworkRightView(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        rv.onSelect = { [weak self] code in self?.selectNetwork(code) }

        textField.rightView = rv
        textField.rightViewMode = .never
        self.rightView = rv

        // Apply cached state
        rv.configure(availableCodes: cachedNetworks, selectedCode: cachedActive)
    }

    @objc public func update(
        detectedCodes: NSSet,
        cardNumber: String,
        selectedCode: String?
    ) {
        let codes = (detectedCodes.allObjects as? [String]) ?? []
        let networksArray = HPFCardSchemeCoordinator.shared
            .getAvailableNetworks(forDetectedCodes: Set(codes), cardNumber: cardNumber)
            .sorted()
            
        updateUI(networks: networksArray, cardNumber: cardNumber, selectedCode: selectedCode)
    }

    @objc public func update(
        orderedNetworks: [String],
        cardNumber: String,
        selectedCode: String?
    ) {
        updateUI(networks: orderedNetworks, cardNumber: cardNumber, selectedCode: selectedCode)
    }

    private func updateUI(networks: [String], cardNumber: String, selectedCode: String?) {
        cachedDetectedCodes = NSSet(array: networks)
        cachedCardNumber = cardNumber
        cachedNetworks = networks
        
        let networksToUse = networks.isEmpty ? [] : networks
        
        let active: String? = {
            if let selectedCode, networksToUse.contains(selectedCode) { return selectedCode }
            if let cachedActive, networksToUse.contains(cachedActive) { return cachedActive }
            if let first = networksToUse.first { return first }
            return nil
        }()
        
        cachedActive = active
        
        rightView?.configure(availableCodes: cachedNetworks, selectedCode: active)
        
        if cachedNetworks.isEmpty {
            textField?.rightViewMode = .never
        } else {
            textField?.rightViewMode = .always
        }
        
        rightView?.invalidateIntrinsicContentSize()
        textField?.setNeedsLayout()
        textField?.layoutIfNeeded()
    }
    
    private func selectNetwork(_ code: String) {
        self.cachedActive = code
        self.rightView?.configure(availableCodes: cachedNetworks, selectedCode: code)
        self.handler?.didPickNetwork(productCode: code)
        self.update(detectedCodes: self.cachedDetectedCodes, cardNumber: self.cachedCardNumber, selectedCode: code)
    }
}
