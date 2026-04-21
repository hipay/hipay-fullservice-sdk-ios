import Foundation

@objc class DemoTestCards: NSObject {

    @objc static let visa = "4111111111111111"
    @objc static let mastercard = "5399999999999999"
    @objc static let amex = "374945314019115"
    @objc static let maestro = "6799990100000000019"
    @objc static let bcmc = "6703444444444449"
    @objc static let cb = "4970100000000003"

    @objc static let allCards: [[String: String]] = [
        ["name": "Visa", "number": visa, "cvv": "123"],
        ["name": "MasterCard", "number": mastercard, "cvv": "123"],
        ["name": "American Express", "number": amex, "cvv": "1234"],
        ["name": "Maestro", "number": maestro, "cvv": ""],
        ["name": "Bancontact", "number": bcmc, "cvv": ""],
        ["name": "CB", "number": cb, "cvv": "123"],
    ]
}
