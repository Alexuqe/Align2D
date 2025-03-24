//
//  CustomLabel.swift
//  Align2D
//
//  Created by Sasha on 19.03.25.
//

import UIKit

extension UILabel {

    convenience init(text: String) {
        self.init()
        self.text = text
        setupLabel()
    }

    private func setupLabel() {
        self.textColor = .darkText
        self.font = .systemFont(ofSize: 15, weight: .medium)
        self.numberOfLines = 1
        self.translatesAutoresizingMaskIntoConstraints = false
    }

}
