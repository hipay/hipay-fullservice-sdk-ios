//
//  Bundle+HiPayLocalization.swift
//  HiPayFullservice
//
//  Created by Said EL MANSOUR on 28/04/2026.
//  Copyright © 2026 HiPay. All rights reserved.
//

import Foundation

private final class HiPayPaymentScreenBundleToken {}

extension Bundle {

    static let hipayPaymentScreenFramework = Bundle(for: HiPayPaymentScreenBundleToken.self)

    static let hipayPaymentScreenLocalization: Bundle = {
        if let path = hipayPaymentScreenFramework.path(forResource: "HPFPaymentScreenLocalization", ofType: "bundle"),
           let bundle = Bundle(path: path) {
            return bundle
        }
        return hipayPaymentScreenFramework
    }()

    static let hipayPaymentScreenViews: Bundle = {
        if let path = hipayPaymentScreenFramework.path(forResource: "HPFPaymentScreenViews", ofType: "bundle"),
           let bundle = Bundle(path: path) {
            return bundle
        }
        return hipayPaymentScreenFramework
    }()

    static func hipayPaymentScreenLocalizedString(forKey key: String) -> String {
        let mainBundleValue = Bundle.main.localizedString(forKey: key, value: key, table: nil)
        if mainBundleValue != key {
            return mainBundleValue
        }
        return NSLocalizedString(
            key,
            tableName: "Payment-Screen",
            bundle: hipayPaymentScreenLocalization,
            comment: ""
        )
    }
}
