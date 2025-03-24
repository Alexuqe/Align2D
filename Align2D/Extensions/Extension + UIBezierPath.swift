//
//  Extension + UIBezierPath.swift
//  Align2D
//
//  Created by Sasha on 24.03.25.
//

import UIKit

extension UIBezierPath {

    func addArrow(start: CGPoint, end: CGPoint) {
            self.move(to: start)
            self.addLine(to: end)

            let pointerLineLength: CGFloat = 20
            let arrowAngle = CGFloat(Double.pi / 6)

            let angle = atan2(end.y - start.y, end.x - start.x)
            let arrowLine1 = CGPoint(
                x: end.x - pointerLineLength * cos(angle - arrowAngle),
                y: end.y - pointerLineLength * sin(angle - arrowAngle)
            )

            let arrowLine2 = CGPoint(
                x: end.x - pointerLineLength * cos(angle + arrowAngle),
                y: end.y - pointerLineLength * sin(angle + arrowAngle)
            )

            self.addLine(to: arrowLine1)
            self.addLine(to: end)
            self.addLine(to: arrowLine2)
        }
}
