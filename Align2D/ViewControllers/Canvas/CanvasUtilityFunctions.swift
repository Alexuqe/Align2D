import SpriteKit

extension CanvasScene {
        // MARK: - Point Types
    enum MovingPointType {
        case startPoint
        case endPoint
        case wholeVector
    }

    struct SnapPoint {
        let point: CGPoint
        let vector: SKShapeNode
    }

        // MARK: - Point Detection
    func detectMovingPoint(for vectorNode: SKShapeNode, touchLocation: CGPoint) -> MovingPointType? {
        guard let path = vectorNode.path else {
            print("⚠\u{fef} Vector path is nil")
            return nil
        }

        let points = getVectorPoints(from: path)
        let threshold: CGFloat = 100.0

        let distanceToStart = distance(from: touchLocation, to: points.start)
        let distanceToEnd = distance(from: touchLocation, to: points.end)

        if distanceToStart < threshold {
            return .startPoint
        } else if distanceToEnd < threshold {
            return .endPoint
        }

        let distanceToLine = distanceToVectorLine(point: touchLocation,
                                                  start: points.start,
                                                  end: points.end)
        if distanceToLine < threshold / 2 {
            return .wholeVector
        }

        return nil
    }

        // MARK: - Distance Calculations
    func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        let dx = from.x - to.x
        let dy = from.y - to.y
        return sqrt(dx * dx + dy * dy)
    }

    func distanceToVectorLine(point: CGPoint, start: CGPoint, end: CGPoint) -> CGFloat {
        let a = end.y - start.y
        let b = start.x - end.x
        let c = end.x * start.y - start.x * end.y

        let distance = abs(a * point.x + b * point.y + c) / sqrt(a * a + b * b)

        let dotProduct = ((point.x - start.x) * (end.x - start.x) +
                          (point.y - start.y) * (end.y - start.y))
        let lengthSquared = pow(end.x - start.x, 2) + pow(end.y - start.y, 2)
        let t = dotProduct / lengthSquared

        if t < 0 || t > 1 {
            return CGFloat.infinity
        }

        return distance
    }

        // MARK: - Vector Point Extraction
    func getVectorPoints(from path: CGPath) -> (start: CGPoint, end: CGPoint) {
        var points: [CGPoint] = []

        path.applyWithBlock { elementPtr in
            let element = elementPtr.pointee
            if element.type == .moveToPoint || element.type == .addLineToPoint {
                points.append(element.points[0])
            }
        }

        guard points.count >= 2 else { return (.zero, .zero) }
        return (start: points[0], end: points[1])
    }
}
