//
//  UIImage+HiPayBrand.swift
//  HiPayFullservice
//
//  Created by Said EL MANSOUR on 25/04/2026.
//  Copyright © 2026 HiPay. All rights reserved.
//

import UIKit

extension UIImage {

    static func hipayBrandImage(for brand: String?) -> UIImage? {
        let bundle = Bundle.hipayPaymentScreenViews
        let defaultImage = UIImage(named: "ic_credit_card", in: bundle, compatibleWith: nil)

        guard let brand, !brand.isEmpty else { return defaultImage }

        let assetName: String
        switch brand.lowercased() {
        case HPFPaymentProductCodeVisa.lowercased():
            assetName = "VISA"
        case HPFPaymentProductCodeMasterCard.lowercased():
            assetName = "MASTERCARD"
        case HPFPaymentProductCodeAmericanExpress.lowercased():
            assetName = "AMEX"
        case HPFPaymentProductCodeDiners.lowercased():
            assetName = "ic_credit_card_diners"
        case HPFPaymentProductCodeCB.lowercased():
            assetName = "CB"
        case HPFPaymentProductCodeBCMC.lowercased():
            assetName = "BCMC"
        case HPFPaymentProductCodeMaestro.lowercased():
            assetName = "MAESTRO"
        default:
            return defaultImage
        }

        return UIImage(named: assetName, in: bundle, compatibleWith: nil) ?? defaultImage
    }
}
