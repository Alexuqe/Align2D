//
//  Extension + SKShapeNode.swift
//  Align2D
//
//  Created by Sasha on 24.03.25.
//

import Foundation
import SpriteKit

extension SKShapeNode {
    func addArrow(path: UIBezierPath) -> SKShapeNode {
        let arrow = SKShapeNode(path: path.cgPath, centered: false)
        arrow.position = CGPoint(x: 0, y: 0)
        arrow.lineWidth = 5
        arrow.strokeColor = UIColor.randomColor()
        arrow.zPosition = 1
        return arrow
    }
}
