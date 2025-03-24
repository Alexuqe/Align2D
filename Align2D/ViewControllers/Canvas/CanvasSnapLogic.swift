import SpriteKit

extension CanvasScene {
        // MARK: - Snapping Logic
    func snapToAxes(point: CGPoint, relativeTo: CGPoint) -> CGPoint {
        var snappedPoint = point
        
        if abs(point.y - relativeTo.y) < snapThreshold {
            snappedPoint.y = relativeTo.y
        }
        if abs(point.x - relativeTo.x) < snapThreshold {
            snappedPoint.x = relativeTo.x
        }
        
        return snappedPoint
    }
    
    func findNearestSnapPoint(to point: CGPoint, excluding currentNode: SKShapeNode) -> SnapPoint? {
        var nearest: SnapPoint?
        var minDistance = CGFloat.infinity
        
        for case let vectorNode as SKShapeNode in contentNode.children {
            guard vectorNode != currentNode,
                  let path = vectorNode.path else { continue }
            
            let points = getVectorPoints(from: path)
            
            let startDistance = distance(from: point, to: points.start)
            if startDistance < snapThreshold && startDistance < minDistance {
                minDistance = startDistance
                nearest = SnapPoint(point: points.start, vector: vectorNode)
            }
            
            let endDistance = distance(from: point, to: points.end)
            if endDistance < snapThreshold && endDistance < minDistance {
                minDistance = endDistance
                nearest = SnapPoint(point: points.end, vector: vectorNode)
            }
        }
        
        return nearest
    }
    
        // MARK: - Right Angle Detection
    func checkAndApplyRightAngle(vectorNode: SKShapeNode, otherVector: SKShapeNode, snapPoint: CGPoint) {
        guard let path1 = vectorNode.path,
              let path2 = otherVector.path else { return }
        
        let points1 = getVectorPoints(from: path1)
        let points2 = getVectorPoints(from: path2)
        
        let first = CGPoint(x: points1.end.x - points1.start.x,
                            y: points1.end.y - points1.start.y)
        let secondary = CGPoint(x: points2.end.x - points2.start.x,
                                y: points2.end.y - points2.start.y)
        
        let angle = abs(atan2(secondary.y, secondary.x) - atan2(first.y, first.x))
        if abs(angle - .pi/2) < angleSnapThreshold {
            showRightAngleMarker(at: snapPoint)
        }
    }
    
    func checkAndUpdateRightAngle(for vectorNode: SKShapeNode, at newLocation: CGPoint, pointType: MovingPointType) {
        guard let path = vectorNode.path else { return }
        let currentPoints = getVectorPoints(from: path)
        
        let movedPoints = (pointType == .startPoint) ?
        (start: newLocation, end: currentPoints.end) :
        (start: currentPoints.start, end: newLocation)
        
        for case let otherVector as SKShapeNode in contentNode.children
        where otherVector != vectorNode {
            guard let otherPath = otherVector.path else { continue }
            let otherPoints = getVectorPoints(from: otherPath)
            
            let first = CGPoint(x: movedPoints.end.x - movedPoints.start.x,
                                y: movedPoints.end.y - movedPoints.start.y)
            let secondary = CGPoint(x: otherPoints.end.x - otherPoints.start.x,
                                    y: otherPoints.end.y - otherPoints.start.y)
            
            let angle = abs(atan2(secondary.y, secondary.x) - atan2(first.y, first.x))
            if abs(angle - .pi/2) > angleSnapThreshold {
                removeRightAngleMarker()
                break
            }
        }
    }
    
        // MARK: - Right Angle Marker
    func showRightAngleMarker(at point: CGPoint) {
        rightAngleMarker?.removeFromParent()
        
        let marker = SKShapeNode(rectOf: CGSize(width: 20, height: 20))
        marker.position = point
        marker.fillColor = .blue
        marker.alpha = 0.5
        
        rightAngleMarker = marker
        contentNode.addChild(marker)
    }
    
    func removeRightAngleMarker() {
        guard selectedVector != nil,
              movingPointType != nil else { return }
        
        rightAngleMarker?.removeFromParent()
        rightAngleMarker = nil
    }
}
