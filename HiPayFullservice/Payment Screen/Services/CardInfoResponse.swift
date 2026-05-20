//
//  CardInfoResponse.swift
//  Pods
//
//  Created by Mansour Said on 13/2/2026.
//

import Foundation

@objc public final class CardInfoResponse: NSObject, Codable, @unchecked Sendable {
    @objc public let brand: String
    @objc public let domesticNetwork: String?
    @objc public let cardType: String?
    @objc public let issuer: String?
    @objc public let token: String?
    @objc public let requestId: String?

    enum CodingKeys: String, CodingKey {
        case brand
        case domesticNetwork = "domestic_network"
        case cardType = "card_type"
        case issuer
        case token
        case requestId = "request_id"
    }

    @objc public var allAvailableNetworks: [String] {
        var networks: [String] = []

        if let domestic = domesticNetwork {
            networks.append(HPFPaymentProduct.productCode(forAPIBrand: domestic))
        }

        let brandCode = HPFPaymentProduct.productCode(forAPIBrand: brand)
        if !networks.contains(brandCode) {
            networks.append(brandCode)
        }

        return networks
    }
}
