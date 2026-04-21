//
//  HPFCardNetworkSelectionHandling.swift
//  Pods
//
//  Created by Mansour Said on 11/1/2026.
//

import UIKit

@objc public protocol HPFCardNetworkSelectionHandling: AnyObject {
    func didPickNetwork(productCode: String)
}
