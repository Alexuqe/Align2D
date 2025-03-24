    //
    //  CustomTextField.swift
    //  Align2D
    //
    //  Created by Sasha on 19.03.25.
    //

import UIKit

extension UITextField {

    convenience init(placeholder: String) {
            self.init()
            self.placeholder = placeholder
            self.textColor = .black
            self.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            self.borderStyle = .roundedRect
            self.translatesAutoresizingMaskIntoConstraints = false

            self.keyboardType = .numbersAndPunctuation
            self.returnKeyType = .next
        }

}
