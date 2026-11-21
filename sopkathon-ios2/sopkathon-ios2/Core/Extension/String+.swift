//
//  String+.swift
//  sopkathon-ios2
//
//  Created by dayeon on 11/21/26.
//

import Foundation

extension String {
    var formattedPhoneNumber: String {
        let digits = filter { $0.isASCII && $0.isNumber }.prefix(PhoneNumber.maxDigitCount)
        let prefixCount = PhoneNumber.prefixCount
        let lastStartIndex = prefixCount + PhoneNumber.middleCount

        let prefix = String(digits.prefix(prefixCount))
        guard digits.count > prefixCount else { return prefix }

        let middle = String(digits.dropFirst(prefixCount).prefix(PhoneNumber.middleCount))
        guard digits.count > lastStartIndex else {
            return [prefix, middle].joined(separator: PhoneNumber.separator)
        }

        let last = String(digits.dropFirst(lastStartIndex))
        return [prefix, middle, last].joined(separator: PhoneNumber.separator)
    }

    var isValidPhoneNumber: Bool {
        range(of: PhoneNumber.pattern, options: .regularExpression) != nil
    }
}

private enum PhoneNumber {
    static let maxDigitCount = 11
    static let prefixCount = 3
    static let middleCount = 4
    static let separator = "-"
    static let pattern = #"^010-\d{4}-\d{4}$"#
}
