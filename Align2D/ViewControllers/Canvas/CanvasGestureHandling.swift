import SpriteKit

extension CanvasScene {
        // MARK: - Gesture Setup
        // MARK: - Gesture Setup
    func setupGestures(for view: SKView) {
        let longPress = setupLongPressGesture(for: view)
        setupPanGesture(for: view, longPress: longPress)
        view.isMultipleTouchEnabled = true
    }
    
    private func setupLongPressGesture(for view: SKView) -> UILongPressGestureRecognizer {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        longPressGesture.minimumPressDuration = 0.3
        longPressGesture.allowableMovement = 10
        view.addGestureRecognizer(longPressGesture)
        return longPressGesture
    }
    
    private func setupPanGesture(for view: SKView, longPress: UILongPressGestureRecognizer) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.delaysTouchesBegan = false
        panGesture.cancelsTouchesInView = false
        panGesture.require(toFail: longPress)
        view.addGestureRecognizer(panGesture)
    }
    
        // MARK: - Pan Gesture Handling
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard selectedVector == nil else { return }
        handlePanGestureState(gesture)
    }
    
    private func handlePanGestureState(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
            case .began:
                handlePanBegan(gesture)
            case .changed:
                handlePanChanged(gesture)
            case .ended, .cancelled:
                handlePanEnded()
            default:
                break
        }
    }
    
    private func handlePanBegan(_ gesture: UIPanGestureRecognizer) {
        initialPanLocation = gesture.location(in: gesture.view)
    }
    
    private func handlePanChanged(_ gesture: UIPanGestureRecognizer) {
        guard let initialLocation = initialPanLocation else { return }
        let currentLocation = gesture.location(in: gesture.view)
        let offset = distance(from: initialLocation, to: currentLocation)
        
        if offset > 20 {
            updateCanvasPosition(with: gesture)
        }
    }
    
    private func updateCanvasPosition(with gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let newPosition = CGPoint(
            x: contentNode.position.x + translation.x,
            y: contentNode.position.y + translation.y
        )
        
        contentNode.position = newPosition
        gridNode.position = newPosition
        
        gesture.setTranslation(.zero, in: gesture.view)
    }
    
    private func handlePanEnded() {
        initialPanLocation = nil
    }
    
        // MARK: - Long Press Gesture Handling
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let view = self.view else { return }
        handleLongPressGestureState(gesture, in: view)
    }
    
    private func handleLongPressGestureState(_ gesture: UILongPressGestureRecognizer, in view: SKView) {
        let locationInView = gesture.location(in: view)
        var sceneLocation = convertPoint(fromView: locationInView)
        sceneLocation = adjustLocationForContentNode(sceneLocation)
        
        switch gesture.state {
            case .began:
                handleGestureBegan(at: sceneLocation)
            case .changed:
                handleGestureChanged(at: sceneLocation)
            case .ended, .cancelled:
                handleGestureEnded()
            default:
                break
        }
    }
    
        // MARK: - Gesture End Handling
    private func handleGestureEnded() {
        guard let vectorNode = selectedVector,
              let path = vectorNode.path else { return }
        
        let points = getVectorPoints(from: path)
        saveVectorChanges(vectorNode: vectorNode, points: points)
        
        selectedVector = nil
        movingPointType = nil
    }
    
    private func adjustLocationForContentNode(_ location: CGPoint) -> CGPoint {
        return CGPoint(
            x: location.x - contentNode.position.x,
            y: location.y - contentNode.position.y
        )
    }
    
        // MARK: - Vector Point Handling
    private func handleGestureBegan(at location: CGPoint) {
        let sceneLocation = convertLocationToScene(location)
        detectAndSelectVector(at: sceneLocation, originalLocation: location)
    }
    
    private func convertLocationToScene(_ location: CGPoint) -> CGPoint {
        return CGPoint(
            x: location.x + contentNode.position.x,
            y: location.y + contentNode.position.y
        )
    }
    
    private func detectAndSelectVector(at sceneLocation: CGPoint, originalLocation: CGPoint) {
        let nodes = self.nodes(at: sceneLocation).filter { $0.name != "grid" }
        if let vectorNode = nodes.first as? SKShapeNode {
            selectedVector = vectorNode
            movingPointType = detectMovingPoint(for: vectorNode, touchLocation: originalLocation)
        }
    }
    
    private func handleGestureChanged(at location: CGPoint) {
        guard let vectorNode = selectedVector,
              let pointType = movingPointType,
              let path = vectorNode.path else { return }
        
        let currentPoints = getVectorPoints(from: path)
        var newLocation = location
        
        switch pointType {
            case .startPoint, .endPoint:
                handleEndpointMovement(vectorNode: vectorNode, pointType: pointType,
                                       currentPoints: currentPoints, newLocation: &newLocation)
            case .wholeVector:
                handleWholeVectorMovement(vectorNode: vectorNode, currentPoints: currentPoints,
                                          newLocation: newLocation)
        }
    }
    
    private func handleEndpointMovement(vectorNode: SKShapeNode, pointType: MovingPointType,
                                        currentPoints: (start: CGPoint, end: CGPoint),
                                        newLocation: inout CGPoint) {
        let referencePoint = pointType == .startPoint ? currentPoints.end : currentPoints.start
        newLocation = snapToAxes(point: newLocation, relativeTo: referencePoint)
        
        handleRightAngleUpdate(for: vectorNode, at: newLocation, pointType: pointType)
        handleSnapPointUpdate(for: vectorNode, at: &newLocation)
        
        updateVectorPath(vectorNode: vectorNode, pointType: pointType, newLocation: newLocation)
    }
    
    private func handleRightAngleUpdate(for vectorNode: SKShapeNode, at newLocation: CGPoint,
                                        pointType: MovingPointType) {
        if rightAngleMarker != nil {
            checkAndUpdateRightAngle(for: vectorNode, at: newLocation, pointType: pointType)
        }
    }
    
    private func handleSnapPointUpdate(for vectorNode: SKShapeNode, at location: inout CGPoint) {
        if let snapPoint = findNearestSnapPoint(to: location, excluding: vectorNode) {
            location = snapPoint.point
            checkAndApplyRightAngle(
                vectorNode: vectorNode,
                otherVector: snapPoint.vector,
                snapPoint: location
            )
        }
    }
    
    private func handleWholeVectorMovement(vectorNode: SKShapeNode,
                                           currentPoints: (start: CGPoint, end: CGPoint),
                                           newLocation: CGPoint) {
        if rightAngleMarker != nil {
            removeRightAngleMarker()
        }
        
        moveWholeVector(vectorNode: vectorNode, from: currentPoints, to: newLocation)
    }
    
}
