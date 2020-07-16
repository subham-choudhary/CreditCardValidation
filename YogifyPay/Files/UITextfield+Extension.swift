//
//  UITextfield+Extension.swift
//  YogifyPay
//
//  Created by user177876 on 7/16/20.
//  Copyright © 2020 user177876. All rights reserved.
//

import Foundation
import UIKit

enum CardType: String {
    case Unknown, Amex, Visa, MasterCard, Diners, Discover, JCB, Elo

    static let allCards = [Amex, Visa, MasterCard, Diners, Discover, JCB, Elo]

    var regex : String {
        switch self {
        case .Amex:
           return "^3[47][0-9]{5,}$"
        case .Visa:
           return "^4[0-9]{6,}([0-9]{3})?$"
        case .MasterCard:
           return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
        case .Diners:
           return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .Discover:
           return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .JCB:
           return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .Elo:
           return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
        default:
           return ""
        }
    }
}
extension UITextField{

func validateCreditCardFormat() -> (type: CardType, valid: Bool) {
        // Get only numbers from the input string
    guard let input = self.text, let _ = Double(input) else { return (type:.Unknown, valid:false)}
        
    var type: CardType = .Unknown
    var formatted = ""
    var valid = false

    // detect card type
    for card in CardType.allCards {
        if (matchesRegex(regex: card.regex, text: input)) {
            type = card
            break
        }
    }

    // check validity
    valid = luhnCheck(number: input)

    // format
    var formatted4 = ""
    for character in input {
        if formatted4.count == 4 {
            formatted += formatted4 + " "
            formatted4 = ""
        }
        formatted4.append(character)
    }

    formatted += formatted4 // the rest

    // return the tuple
    return (type, valid)
}

func matchesRegex(regex: String!, text: String!) -> Bool {
    do {
        let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
        let nsString = text as NSString
        let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
        return (match != nil)
    } catch {
        return false
    }
}

func luhnCheck(number: String) -> Bool {
    var sum = 0
    let digitStrings = number.reversed().map { String($0) }

    for (index,tuple) in digitStrings.enumerated() {
        guard let digit = Int(tuple) else { return false }
        let odd = index % 2 == 1

        switch (odd, digit) {
        case (true, 9):
            sum += 9
        case (true, 0...8):
            sum += (digit * 2) % 9
        default:
            sum += digit
        }
    }

    return sum % 10 == 0
}
}
