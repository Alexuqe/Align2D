//
//  Extension + UIBezierPath.swift
//  Align2D
//
//  Created by Sasha on 24.03.25.
//

import UIKit

extension UIBezierPath {
//    func addArrow(start: CGPoint, end: CGPoint) {
//        self.move(to: start)
//        self.addLine(to: end)
//
//        let pointerLineLength: CGFloat = 20
//        let arrowAngle = CGFloat(Double.pi / 5)
//
//        let startEndAngle = atan((end.y - start.y) / (end.x - start.x)) + ((end.x - start.x) < 0 ? CGFloat(Double.pi) : 0)
//        let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
//        let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))
//
//        self.addLine(to: arrowLine1)
//        self.move(to: end)
//        self.addLine(to: arrowLine2)
//    }

    func addArrow(start: CGPoint, end: CGPoint) {
            // Рисуем основную линию
            self.move(to: start)
            self.addLine(to: end)

            // Параметры стрелки
            let pointerLineLength: CGFloat = 20
            let arrowAngle = CGFloat(Double.pi / 6)

            // Вычисляем угол вектора
            let angle = atan2(end.y - start.y, end.x - start.x)

            // Вычисляем точки стрелки
            let arrowLine1 = CGPoint(
                x: end.x - pointerLineLength * cos(angle - arrowAngle),
                y: end.y - pointerLineLength * sin(angle - arrowAngle)
            )

            let arrowLine2 = CGPoint(
                x: end.x - pointerLineLength * cos(angle + arrowAngle),
                y: end.y - pointerLineLength * sin(angle + arrowAngle)
            )

            // Добавляем линии стрелки, используя addLine для непрерывного пути
            self.addLine(to: arrowLine1)
            self.addLine(to: end)
            self.addLine(to: arrowLine2)
        }
}
