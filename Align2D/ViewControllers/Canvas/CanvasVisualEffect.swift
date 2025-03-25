import SpriteKit

extension CanvasScene {
        // MARK: - Vector Highlighting
    func highLightVector(by id: UUID) {
        contentNode.children.forEach { node in
            if let shapeNode = node as? SKShapeNode {
                shapeNode.lineWidth = 2.0
                shapeNode.glowWidth = 0.0
            }
        }

        guard let vectorNode = contentNode.children
            .first(where: { $0.name == id.uuidString }) as? SKShapeNode else { return }

        vectorNode.lineWidth = 5.0
        vectorNode.glowWidth = 1.0
    }

    func resetHighlight() {
        contentNode.children.forEach { node in
            if let shapeNode = node as? SKShapeNode {
                shapeNode.lineWidth = 2.0
                shapeNode.glowWidth = 0.0
                shapeNode.setScale(1.0)
            }
        }
    }
}
