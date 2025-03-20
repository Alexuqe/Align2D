//
//  Extension + UIView.swift
//  Align2D
//
//  Created by Sasha on 19.03.25.
//

import UIKit

extension UIView {
    func addSubviews(_ view: UIView...) {
        view.forEach { subview in
            self.addSubview(subview)
        }
    }
}
