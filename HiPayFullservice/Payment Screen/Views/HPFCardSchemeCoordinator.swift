//
//  HPFCardSchemeCoordinator.swift
//  Pods
//
//  Created by Mansour Said on 10/1/2026.
//

import UIKit

@objc public final class HPFCardSchemeCoordinator: NSObject, @unchecked Sendable {

    @objc public static let shared = HPFCardSchemeCoordinator()

    private let priority: [String: Int] = [
        HPFPaymentProductCodeVisa: 0,
        HPFPaymentProductCodeMasterCard: 0,
        HPFPaymentProductCodeAmericanExpress: 0,
        HPFPaymentProductCodeBCMC: 0,
        HPFPaymentProductCodeMaestro: 1,
        HPFPaymentProductCodeCB: 2
    ]
    
    @objc public func getAvailableNetworks(forDetectedCodes codes: Set<String>, cardNumber: String, allowedPaymentProductCodes: Set<String>? = nil) -> [String] {
        var networks = Set(codes)
        let cleanedNumber = cardNumber.replacingOccurrences(of: " ", with: "")
        
        if let allowed = allowedPaymentProductCodes, !allowed.isEmpty {
            networks = networks.intersection(allowed)
        }
        
        // Sort based on Priority Rules:
        // Rule A: CB / Visa or CB / Mastercard -> CB selected by default (Highest Priority)
        // Rule B: Bancontact / Visa or Bancontact / Master Card or Bancontact / Maestro -> Bancontact selected by default (Highest Priority)
        
        return Array(networks).sorted { a, b in
            let isACB = (a == HPFPaymentProductCodeCB)
            let isBCB = (b == HPFPaymentProductCodeCB)
            
            let isABCMC = (a == HPFPaymentProductCodeBCMC)
            let isBBCMC = (b == HPFPaymentProductCodeBCMC)
            
            if isACB && !isBCB { return true }
            if !isACB && isBCB { return false }
            
            if isABCMC && !isBBCMC { return true }
            if !isABCMC && isBBCMC { return false }
            
            let pa = priority[a] ?? 999
            let pb = priority[b] ?? 999
            
            if pa != pb { return pa < pb }
            return a.localizedCaseInsensitiveCompare(b) == .orderedAscending
        }
    }
    
    @objc public func getAvailableNetworks(forDetectedCodes codes: Set<String>) -> [String] {
        return getAvailableNetworks(forDetectedCodes: codes, cardNumber: "", allowedPaymentProductCodes: nil)
    }
}
