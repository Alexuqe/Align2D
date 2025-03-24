import SpriteKit

extension CanvasScene {
        // MARK: - Vector Drawing

    func addVector(vector: MainViewModels) {
        let path = UIBezierPath()
        path.addArrow(start: CGPoint(x: vector.startX, y: vector.startY),
                      end: CGPoint(x: vector.endX, y: vector.endY))

        let vectorNode = SKShapeNode(path: path.cgPath)
        vectorNode.strokeColor = UIColor(hexString: vector.color)
        vectorNode.lineWidth = 2.0
        vectorNode.lineCap = .round
        vectorNode.name = vector.id.uuidString

        contentNode.addChild(vectorNode)
    }

        // MARK: - Vector Movement
    func moveWholeVector(vectorNode: SKShapeNode, from currentPoints: (start: CGPoint, end: CGPoint), to newLocation: CGPoint) {
        let translation = CGPoint(
            x: newLocation.x - currentPoints.start.x,
            y: newLocation.y - currentPoints.start.y
        )

        let newStart = CGPoint(
            x: currentPoints.start.x + translation.x,
            y: currentPoints.start.y + translation.y
        )
        let newEnd = CGPoint(
            x: currentPoints.end.x + translation.x,
            y: currentPoints.end.y + translation.y
        )

        let newPath = UIBezierPath()
        newPath.addArrow(start: newStart, end: newEnd)
        vectorNode.path = newPath.cgPath
        vectorNode.strokeColor = vectorNode.strokeColor
        vectorNode.lineWidth = 2.0
    }

    func updateVectorPath(vectorNode: SKShapeNode, pointType: MovingPointType, newLocation: CGPoint) {
        guard let path = vectorNode.path else { return }

        let currentPoints = getVectorPoints(from: path)
        let color = vectorNode.strokeColor

        let newPath = UIBezierPath()

        switch pointType {
            case .startPoint:
                newPath.addArrow(start: newLocation, end: currentPoints.end)
            case .endPoint:
                newPath.addArrow(start: currentPoints.start, end: newLocation)
            case .wholeVector:
                moveWholeVector(vectorNode: vectorNode, from: currentPoints, to: newLocation)
                return
        }

        vectorNode.path = newPath.cgPath
        vectorNode.strokeColor = color
        vectorNode.lineWidth = 2.0
    }

        // MARK: - Vector Management
    func removeVector(by id: UUID) {
        contentNode.children
            .filter { $0.name == id.uuidString }
            .forEach { node in
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let remove = SKAction.removeFromParent()
                self.scene?.view?.setNeedsDisplay()
                node.run(SKAction.sequence([fadeOut, remove]))
                node.removeFromParent()
            }
    }

    func saveVectorChanges(vectorNode: SKShapeNode, points: (start: CGPoint, end: CGPoint)) {
        guard let vectorIDString = vectorNode.name,
              let uuid = UUID(uuidString: vectorIDString) else { return }

        storageManager.updateVector(
            id: uuid,
            startX: Double(points.start.x),
            startY: Double(points.start.y),
            endX: Double(points.end.x),
            endY: Double(points.end.y)
        ) { result in
            self.handleVectorUpdateResult(result)
        }
    }

    private func handleVectorUpdateResult(_ result: Result<Void, Error>) {
        switch result {
            case .success:
                print("Изменения вектора успешно сохранены")
            case .failure(let error):
                print("Ошибка при сохранении изменений: \(error)")
        }
    }
}
