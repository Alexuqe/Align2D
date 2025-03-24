    //
    //  CustomButton.swift
    //  Align2D
    //
    //  Created by Sasha on 19.03.25.
    //

import UIKit

extension UIButton {

    convenience init(
        backgroundColor: UIColor,
        foregroundColor: UIColor,
        title: String,
        target: Any?,
        action: Selector
    ) {
        self.init(type: .system)
        self.backgroundColor = backgroundColor
        self.tintColor = foregroundColor
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        self.layer.cornerRadius = 10
        self.translatesAutoresizingMaskIntoConstraints = false

            // Используем addTarget вместо замыкания
        self.addTarget(target, action: action, for: .touchUpInside)
    }


}
