//
//  CanvasScene.swift
//  Align2D
//
//  Created by Sasha on 18.03.25.
//

import SpriteKit

final class CanvasScene: SKScene {

    private var vectors: [UUID: SKShapeNode] = [:]
    private var offset: CGPoint = .zero

    func addVector(id: UUID, start: CGPoint, end: CGPoint, color: UIColor) {
        let path = CGMutablePath()
        path.move(to: start)
        path.addLine(to: end)

        let vector = SKShapeNode(path: path)
        vector.strokeColor = color
        vector.lineWidth = 2
        addChild(vector)
        vectors[id] = vector
    }

    func clearCanvas() {
        for (_, vectors) in vectors {
            vectors.removeFromParent()
        }
        vectors.removeAll()
    }

    func updateOffset(offset: CGPoint) {
        self.offset = offset
        position = offset
    }




}
