HiPay iOS SDK change log and release notes
================================================

1.11.4
-----
* Add new parameter for Apple Pay

1.11.3
-----
* fix brand with space

1.11.2
-----
* Replace UIWebView (deprecated) by WKWebView
* Adding case insensitive for card brand 
* Domestic network has priority over brand network

1.11.1
-----
* SDK : Fix empty screen when using card storage feature

1.11.0
-----

* Project : Compiled with Xcode 11.3
* Demo : Dark mode (only on iOS 13)
* SDK : Dark mode (only on iOS 13)
* SDK : Fix the cancel button disappear sometimes

1.10.0
-----
* SDK : Add PSD2 compliance
* SDK : Handle more errors & Add error localizations

1.9.2
-----
* SDK : Fix crash in HPFOrderRelatedRequest initialization when using only HiPayFullservice/Core integration

1.9.1
-----
* SDK : Fix Source object initialization in order object
* SDK : Add timeout property to payment page
* SDK : Add gradient in payment products
* Project : Remove all warnings in XCode 10.2.1

1.9.0
-----
* SDK : Add Sepa Direct Debit
* SDK : Add ContentType in TextField
* Demo Application : Environment choice screen
* Demo Application : Local signature
* Project : Remove all warnings in XCode 10.1
* Project : Update README.md

1.8.1
-----
* Update Datesc Library (1.08.4701)
* Remove old function lookup

1.8.0
-----
* Add support Mastercard BIN 2.
* Use Secure vault V2.
* Fix uri encoding for request.

1.7.0
-----
* Add the card storage screen.

1.6.3
-----
* Fix the UTF8 URL string encoding.

1.6.2
-----
* Resolves the empty reason in transactions.

1.6.1
-----
* Resolves i386 architectures warnings.

1.6.0
-----
* Integrate the Datecs library to make the BluePad-500 work.

1.5.2
-----
* Fix the payment form with Maestro cards.

1.5.1
-----
* Let the client config handle Apple Pay option.

1.5.0
-----
* Add the Apple Pay feature.

1.4.1
-----
* Resolves static library error on swift projects.

1.4.0
-----
* Add more logging to errors.

1.3.0
-----
* Add the scan card camera feature.

1.2.0
-----
* Improves the 1-click payment feature with the fingerprint recognition (Touch ID) as an option to secure future payments with a stored card.

1.1.0
-----
* Add the 1-click payment feature.

1.0.0
-----
* First major version of the HiPay Enterprise iOS SDK.
