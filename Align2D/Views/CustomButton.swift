//
//  CustomButton.swift
//  Align2D
//
//  Created by Sasha on 19.03.25.
//

import UIKit

extension UIButton {

    convenience init(backgroundColor: UIColor, foregroundColor: UIColor, title: String, target: AnyObject, action: Selector) {
        self.init()
        setupButton(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            title: title,
            target: target,
            action: action
        )
    }

    private func setupButton(backgroundColor: UIColor, foregroundColor: UIColor, title: String, target: AnyObject,action: Selector) {
        var configure = UIButton.Configuration.filled()
        configure.baseBackgroundColor = backgroundColor
        configure.baseForegroundColor = foregroundColor
        configure.cornerStyle = .capsule
        configure.title = title

        self.configuration = configure
        
        self.translatesAutoresizingMaskIntoConstraints = false

        self.addTarget(target, action: action, for: .touchUpInside)
    }

}
