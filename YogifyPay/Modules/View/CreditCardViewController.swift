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
    }
    
    func resetSpaces(_ textField: UITextField) {
        
        guard let text = textField.text, editFlag else { return }
        editFlag = false
        var trimmedText = text.filter{ !" ".contains($0)}
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
    }
    
}

extension CreditCardViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print(textField.validateCreditCardFormat())
        editFlag = true
        return (textField.text?.count ?? 0) + (string.count - range.length) <= 19
    }

}
