//
//  ViewController.swift
//  YogifyPay
//
//  Created by user177876 on 7/16/20.
//  Copyright © 2020 user177876. All rights reserved.
//

import UIKit


class CreditCardViewController: UIViewController {
    
    @IBOutlet weak var labelPlaceholder: UILabel!
    @IBOutlet weak var textFieldCardNumber: UITextField!
    
    var editFlag = false
    var viewModel = CreditCardViewModel()
    var cardType: CardType = .Unknown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        textFieldCardNumber.delegate = self
        textFieldCardNumber.addTarget(self, action: #selector(CreditCardViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        resetSpaces(textField)
        modifyPlaceHolder(textField)
//        print(textField.validateCreditCardFormat())
        
    }
    
    func resetSpaces(_ textField: UITextField) {
        
        guard let text = textField.text, editFlag else { return }
        editFlag = false
        let cursorSelectedTextRange = textField.selectedTextRange
        
        let textCountBeforeTrimming = text.count
        let trimmedText = text.filter{ !" ".contains($0)}
        var newText = ""
        
        for (index,element) in trimmedText.enumerated() {
            let char = (String(element))
            if (index) % 4 == 0 && index > 0 {
                newText.append(" \(char)")
            } else {
                newText.append(char)
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
        guard let text = textField.text else {return}
        
        let range = NSRange(location: 0, length: text.count)
        let attribute = NSMutableAttributedString.init(string: labelPlaceholder.text ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white , range: range)
        labelPlaceholder.attributedText = attribute
    }
}

extension CreditCardViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print(range, string)

        editFlag = true
        return (textField.text?.count ?? 0) + (string.count - range.length) <= 19
    }

}
