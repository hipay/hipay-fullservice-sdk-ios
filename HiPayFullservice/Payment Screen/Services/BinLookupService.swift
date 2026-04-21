//
//  BinLookupService.swift
//  Pods
//
//  Created by Mansour Said on 12/2/2026.
//

import Foundation

@objc public final class BinLookupService: NSObject, @unchecked Sendable {

    @objc public static let shared = BinLookupService()

    private override init() {}

    @objc public func lookupWithBin(_ bin: String, completion: @escaping (CardInfoResponse?, NSError?) -> Void) {
        let config = HPFClientConfig.shared()
        let baseURLString = (config.environment == .stage)
            ? HPFSecureVaultClientNewBaseURLStage
            : HPFSecureVaultClientNewBaseURLProduction

        guard let baseURL = URL(string: baseURLString) else {
            completion(nil, NSError(domain: HPFHiPayFullserviceErrorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid BIN lookup URL"]))
            return
        }

        let client = HPFHTTPClient(
            baseURL: baseURL,
            newBaseURL: baseURL,
            username: config.username ?? "",
            password: config.password ?? ""
        )

        let nextYear = String(Calendar.current.component(.year, from: Date()) + 1)
        let params: [String: Any] = [
            "card_number": bin,
            "card_expiry_year": nextYear,
            "card_expiry_month": "12"
        ]

        // The completion handler from performRequest retains `client` via the
        // capture list, keeping it alive for the duration of the request.
        client.performRequest(
            with: .post,
            v2: true,
            path: "token",
            parameters: params
        ) { response, error in
            _ = client // retain client until completion

            if let error = error {
                completion(nil, error as NSError)
                return
            }

            guard let body = response?.body as? [String: Any] else {
                completion(nil, NSError(domain: HPFHiPayFullserviceErrorDomain, code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid BIN lookup response"]))
                return
            }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: body)
                let result = try JSONDecoder().decode(CardInfoResponse.self, from: jsonData)
                completion(result, nil)
            } catch {
                completion(nil, error as NSError)
            }
        }
    }
}
