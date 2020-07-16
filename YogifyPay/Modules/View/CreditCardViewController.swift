//
//  ViewController.swift
//  YogifyPay
//
//  Created by user177876 on 7/16/20.
//  Copyright © 2020 user177876. All rights reserved.
//

import UIKit

enum ContainerType: String {
    case sixteenDigit = "XXXX XXXX XXXX XXXX"
    case fifteenDigit = "XXXX XXXXXX XXXXX"
    case forteenDigit = "XXXX XXXXXX XXXX"
}

class CreditCardViewController: UIViewController {
    
    @IBOutlet weak var labelPlaceholder: UILabel!
    @IBOutlet weak var textFieldCardNumber: UITextField!
    
    var editFlag = false
    var viewModel = CreditCardViewModel()
    var cardType: CardType = .Unknown
    var containerType: ContainerType = .sixteenDigit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        textFieldCardNumber.delegate = self
        textFieldCardNumber.addTarget(self, action: #selector(CreditCardViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let (cardType, valid) = textField.validateCreditCardFormat()
        setupCardType(cardType: cardType, valid: valid) //Should be called first
        resetSpaces(textField)
        modifyPlaceHolder(textField)
        
        
    }
    func setupCardType(cardType: CardType, valid: Bool) {
        switch cardType {
        case .Unknown, .MasterCard, .JCB, .Discover, .Elo, .Maestro, .Visa: containerType = .sixteenDigit
        case .Amex: containerType = .fifteenDigit
        case .Diners: containerType = .forteenDigit
        }
    }
    
    func resetSpaces(_ textField: UITextField) {
        
        guard let text = textField.text, editFlag else { return }
        editFlag = false
        let cursorSelectedTextRange = textField.selectedTextRange
        
        let textCountBeforeTrimming = text.count
        let trimmedText = text.filter{ !" ".contains($0)}
        var newText = ""
        
        switch containerType {
        
        case .sixteenDigit:
            for (index,element) in trimmedText.enumerated() {
                let char = (String(element))
                if (index) % 4 == 0 && index > 0 {
                    newText.append(" \(char)")
                } else {
                    newText.append(char)
                }
            }
        case .fifteenDigit, .forteenDigit:
            for (index,element) in trimmedText.enumerated() {
                let char = (String(element))
                if index == 4 || index == 11 {
                    newText.append(" \(char)")
                } else {
                    newText.append(char)
                }
            }
        }
        
        textField.text = newText
        if textCountBeforeTrimming != newText.count {
            if let range = cursorSelectedTextRange {
                if let newPosition = textField.position(from: range.start, in: .right, offset: 1) {
                    textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
                }
            }
        } else {
            textField.selectedTextRange = cursorSelectedTextRange
        }
    }
    
    func modifyPlaceHolder(_ textField: UITextField) {
        guard let text = textField.text, text.count <= labelPlaceholder.text?.count ?? 0 else { return }
        labelPlaceholder.text = containerType.rawValue
        
        let range = NSRange(location: 0, length: text.count)
        let attribute = NSMutableAttributedString.init(string: labelPlaceholder.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let darkGrayColor = UIColor(displayP3Red: 33/255, green: 33/255, blue: 33/255, alpha: 0.93)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: darkGrayColor , range: range)
        labelPlaceholder.attributedText = attribute
    }
}

extension CreditCardViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        editFlag = true
        return (textField.text?.count ?? 0) + (string.count - range.length) <= containerType.rawValue.count
    }

}
