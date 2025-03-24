import SpriteKit

extension CanvasScene {
        // MARK: - Grid Drawing
    func setupStaticLargeGrid() {
        gridNode.removeAllChildren()
        
        let gridSize: CGFloat = 10000
        let gridSpacing: CGFloat = 30.0
        
        let path = CGMutablePath()
        
        let startX = -gridSize / 2
        let startY = -gridSize / 2
        let endX = gridSize / 2
        let endY = gridSize / 2
        
        for x in stride(from: startX, through: endX, by: gridSpacing) {
            path.move(to: CGPoint(x: x, y: startY))
            path.addLine(to: CGPoint(x: x, y: endY))
        }
        
        for y in stride(from: startY, through: endY, by: gridSpacing) {
            path.move(to: CGPoint(x: startX, y: y))
            path.addLine(to: CGPoint(x: endX, y: y))
        }
        
        let gridLines = SKShapeNode(path: path)
        gridLines.name = "grid"
        gridLines.strokeColor = .systemGray4
        gridLines.lineWidth = 0.4
        gridLines.zPosition = -1000
        
        gridNode.addChild(gridLines)
    }
}
