import SpriteKit

extension CanvasScene {
        // MARK: - Vector Highlighting
    func highLightVector(by id: UUID) {
        print("CanvasScene: Starting highlight for vector ID: \(id.uuidString)")
        
        contentNode.children.forEach { node in
            if let shapeNode = node as? SKShapeNode {
                shapeNode.lineWidth = 2.0
                shapeNode.glowWidth = 0.0
            }
        }
        
        guard let vectorNode = contentNode.children
            .first(where: { $0.name == id.uuidString }) as? SKShapeNode else {
            print("CanvasScene: Vector node not found for ID: \(id.uuidString)")
            return
        }
        
        print("CanvasScene: Vector found, applying highlight")
        vectorNode.lineWidth = 5.0
        vectorNode.glowWidth = 1.0
    }
    
    func resetHighlight() {
        print("CanvasScene: Resetting all vector highlights")
        contentNode.children.forEach { node in
            if let shapeNode = node as? SKShapeNode {
                shapeNode.lineWidth = 2.0
                shapeNode.glowWidth = 0.0
                shapeNode.setScale(1.0)
            }
        }
    }
}
