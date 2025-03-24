import SpriteKit

final class CanvasScene: SKScene {
        // MARK: - Properties
    let contentNode = SKNode()
    let gridNode = SKNode()
    var selectedVector: SKShapeNode?
    let storageManager = StorageManager.shared
    var movingPointType: MovingPointType?
    
    let snapThreshold: CGFloat = 10.0
    let angleSnapThreshold: CGFloat = .pi / 36 
    var initialPanLocation: CGPoint?
    var rightAngleMarker: SKShapeNode?
    
        // MARK: - Lifecycle
    override func didMove(to view: SKView) {
        setupScene()
        setupGestures(for: view)
    }
    
    private func setupScene() {
        backgroundColor = .white
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(gridNode)
        addChild(contentNode)
        setupStaticLargeGrid()
    }
    
    func clearCanvas() {
        contentNode.removeAllChildren()
    }
}
