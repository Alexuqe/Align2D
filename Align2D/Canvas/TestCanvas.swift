    //
    //  TestCanvas.swift
    //  Align2D
    //
    //  Created by Sasha on 24.03.25.
    //

    import SpriteKit


    final class CanvasScene: SKScene {
        // MARK: - Properties
        private let contentNode = SKNode()
        private let gridNode = SKNode()
        private var selectedVector: SKShapeNode?
        private let storageManager = StorageManager.shared
        private var movingPointType: MovingPointType?

        private let gridSpacing: CGFloat = 30.0
        private let snapThreshold: CGFloat = 5.0

        enum MovingPointType {
            case startPoint
            case endPoint
        }

        // MARK: - Lifecycle Methods
        override func didMove(to view: SKView) {
            setupScene()
            setupGestures(for: view)
        }

        func highLightVector(by id: UUID) {
            print("CanvasScene: Starting highlight for vector ID: \(id.uuidString)")

            // Сначала сбросим выделение всех векторов
            contentNode.children.forEach { node in
                if let shapeNode = node as? SKShapeNode {
                    shapeNode.lineWidth = 2.0
                    shapeNode.glowWidth = 0.0
                }
            }

            // Найдем и выделим нужный вектор
            guard let vectorNode = contentNode.children
                .first(where: { $0.name == id.uuidString }) as? SKShapeNode else {
                print("CanvasScene: Vector node not found for ID: \(id.uuidString)")
                return
            }

            print("CanvasScene: Vector found, applying highlight")
            vectorNode.lineWidth = 10.0
            vectorNode.glowWidth = 1.0

            // Добавим анимацию подсветки
            let pulseAction = SKAction.sequence([
                SKAction.scale(to: 1.1, duration: 0.2),
                SKAction.scale(to: 1.0, duration: 0.2)
            ])
            vectorNode.run(pulseAction)
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

        func removeVector(by id: UUID) {
            contentNode.children
                .first(where: { $0.name == id.uuidString })?
                .removeFromParent()
        }

        func clearCanvas() {
            contentNode.removeAllChildren()
        }

        private func setupScene() {
            configureSceneBasics()
            setupContentNode()
            setupStaticLargeGrid()
        }

        private func configureSceneBasics() {
            self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.backgroundColor = .white
        }

        private func setupContentNode() {
            addChild(contentNode)
            addChild(gridNode)

            contentNode.position = CGPoint.zero
            gridNode.position = CGPoint.zero
            gridNode.isUserInteractionEnabled = false
        }



        // MARK: - Utility

    }

    // MARK: - Grid Drawing

    extension CanvasScene {
        private func setupStaticLargeGrid() {
            gridNode.removeAllChildren()

            let largeSize = CGSize(width: 10000, height: 10000)
            let path = CGMutablePath()

            // Calculate grid boundaries
            let startX = -largeSize.width / 2
            let startY = -largeSize.height / 2
            let endX = largeSize.width / 2
            let endY = largeSize.height / 2

            // Add vertical lines
            for x in stride(from: startX, through: endX, by: gridSpacing) {
                path.move(to: CGPoint(x: x, y: startY))
                path.addLine(to: CGPoint(x: x, y: endY))
            }

            // Add horizontal lines
            for y in stride(from: startY, through: endY, by: gridSpacing) {
                path.move(to: CGPoint(x: startX, y: y))
                path.addLine(to: CGPoint(x: endX, y: y))
            }

            let gridLines = SKShapeNode(path: path)
            gridLines.name = "grid"
            gridLines.strokeColor = .systemGray4
            gridLines.lineWidth = 0.4
            gridLines.zPosition = -1000

            // Add grid to gridNode
            gridNode.addChild(gridLines)
        }
    }



    // MARK: - Vector Drawing
    extension CanvasScene {

        func addVector(vector: MainViewModels) {
            print("Adding vector - Start: (\(vector.startX), \(vector.startY)) -> End: (\(vector.endX), \(vector.endY))")

            // Проверяем, не существует ли уже вектор с таким ID
            if contentNode.children.contains(where: { $0.name == vector.id.uuidString }) {
                print("Vector with ID \(vector.id.uuidString) already exists, skipping")
                return
            }

            // Создаем путь для вектора
            let path = UIBezierPath()
            path.addArrow(start: CGPoint(x: vector.startX, y: vector.startY),
                         end: CGPoint(x: vector.endX, y: vector.endY))

            // Создаем новый узел
            let vectorNode = SKShapeNode(path: path.cgPath)
            vectorNode.strokeColor = UIColor(hexString: vector.color)
            vectorNode.lineWidth = 2.0
            vectorNode.lineCap = .round
            vectorNode.name = vector.id.uuidString

            // Добавляем узел на сцену
            contentNode.addChild(vectorNode)

            print("Vector added successfully with ID: \(vector.id.uuidString)")
        }

        private func createVectorWithArrow(from vector: MainModel.ShowVectors.ViewModel.DisplayedVector) -> SKShapeNode {
            let startPoint = CGPoint(x: vector.startX, y: vector.startY)
            let endPoint = CGPoint(x: vector.endX, y: vector.endY)

            let path = UIBezierPath()
            path.addArrow(start: startPoint, end: endPoint)

            let arrowNode = SKShapeNode(path: path.cgPath)
            arrowNode.strokeColor = UIColor(hexString: vector.color)
            arrowNode.lineWidth = 2.0
            arrowNode.lineCap = .round
            arrowNode.name = vector.id.uuidString

            return arrowNode
        }

    }

    // MARK: - Gesture Handling
    extension CanvasScene {

        private func setupGestures(for view: SKView) {
            setupPanGesture(for: view)
            setupLongPressGesture(for: view)
        }

        private func setupPanGesture(for view: SKView) {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            view.addGestureRecognizer(panGesture)
        }

        private func setupLongPressGesture(for view: SKView) {
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
            view.addGestureRecognizer(longPressGesture)
        }

        @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
            guard let view = self.view else { return }
            let translation = gesture.translation(in: view)

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                let newPosition = CGPoint(
                    x: contentNode.position.x + translation.x,
                    y: contentNode.position.y + translation.y
                )
                self.contentNode.position = newPosition
                gesture.setTranslation(.zero, in: view)
            }
        }

        @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
            guard let view = self.view else { return }

            // Получаем точку касания в координатах view
            let locationInView = gesture.location(in: view)
            // Конвертируем в координаты сцены
            var sceneLocation = view.convert(locationInView, to: self)
            // Учитываем позицию contentNode
            sceneLocation = contentNode.convert(sceneLocation, from: self)

            switch gesture.state {
                    case .began:
                        print("Touch began at: \(sceneLocation)")
                        // Ищем все узлы в точке касания, исключая сетку
                        let nodes = contentNode.nodes(at: sceneLocation).filter { $0.name != "grid" }

                        if let vectorNode = nodes.first as? SKShapeNode {
                            print("Selected vector: \(vectorNode.name ?? "unknown")")
                            selectedVector = vectorNode
                            movingPointType = detectMovingPoint(for: vectorNode, touchLocation: sceneLocation)
                        }

                    case .changed:
                        guard let vectorNode = selectedVector,
                              let pointType = movingPointType else { return }

                        print("Moving to point: \(sceneLocation)")

                        // Получаем текущие точки вектора в локальных координатах
                        let currentPoints = getVectorPoints(from: vectorNode.path!)

                        // Создаем новый путь
                        let newPath = UIBezierPath()

                        switch pointType {
                            case .startPoint:
                                newPath.move(to: sceneLocation)
                                newPath.addLine(to: currentPoints.end)
                                print("Moving start to: \(sceneLocation)")
                            case .endPoint:
                                newPath.move(to: currentPoints.start)
                                newPath.addLine(to: sceneLocation)
                                print("Moving end to: \(sceneLocation)")
                        }

                        // Сохраняем свойства
                        let color = vectorNode.strokeColor

                        // Применяем изменения
                        vectorNode.path = newPath.cgPath
                        vectorNode.strokeColor = color
                        vectorNode.lineWidth = 2.0

                        // Принудительно обновляем отображение
                        self.view?.setNeedsDisplay()

                    case .ended, .cancelled:
                        print("Touch ended")
                        if let vectorNode = selectedVector {
                            let points = getVectorPoints(from: vectorNode.path!)

                            // Создаем финальный путь со стрелкой
                            let finalPath = UIBezierPath()
                            finalPath.addArrow(start: points.start, end: points.end)

                            let color = vectorNode.strokeColor
                            vectorNode.path = finalPath.cgPath
                            vectorNode.strokeColor = color
                            vectorNode.lineWidth = 2.0

                            // Сохраняем изменения
                            saveVectorChanges(vectorNode: vectorNode, points: points)
                        }

                        selectedVector = nil
                        movingPointType = nil

                    default:
                        break
                }
        }

        private func getVectorPoints(from path: CGPath) -> (start: CGPoint, end: CGPoint) {
            var points: [CGPoint] = []

            path.applyWithBlock { elementPtr in
                let element = elementPtr.pointee
                switch element.type {
                    case .moveToPoint, .addLineToPoint:
                        points.append(element.points[0])
                    default:
                        break
                }
            }

            guard points.count >= 2 else { return (.zero, .zero) }
            return (start: points[0], end: points[1])
        }

        private func detectMovingPoint(for vectorNode: SKShapeNode, touchLocation: CGPoint) -> MovingPointType? {
            guard let path = vectorNode.path else {
                print("⚠️ Vector path is nil")
                return nil
            }

            let points = getVectorPoints(from: path)
            let distanceToStart = distance(from: touchLocation, to: points.start)
            let distanceToEnd = distance(from: touchLocation, to: points.end)

            let threshold: CGFloat = 100.0
            print("📏 Distance to start: \(distanceToStart), to end: \(distanceToEnd)")

            if distanceToStart < threshold {
                return .startPoint
            } else if distanceToEnd < threshold {
                return .endPoint
            }

            return nil
        }

        // Вспомогательный метод для вычисления расстояния
        private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
            let dx = from.x - to.x
            let dy = from.y - to.y
            return sqrt(dx * dx + dy * dy)
        }
    }

    // MARK: - Vector Editing Logic
    extension CanvasScene {

        private func saveVectorChanges(vectorNode: SKShapeNode, points: (start: CGPoint, end: CGPoint)) {
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

    // MARK: - Snapping & Angle Snapping
    extension CanvasScene {

        private func applySnapping(to point: CGPoint, startPoint: CGPoint, endPoint: CGPoint, vectorNode: SKShapeNode?) -> CGPoint {
            var snappedPoint = point
            snappedPoint = applySnappingToOwnPoints(point: snappedPoint, startPoint: startPoint, endPoint: endPoint)
            snappedPoint = applySnappingToOtherVectors(point: snappedPoint, vectorNode: vectorNode)
            return snappedPoint
        }

        private func applySnappingToOwnPoints(point: CGPoint, startPoint: CGPoint, endPoint: CGPoint) -> CGPoint {
            var snappedPoint = point

            if abs(point.x - startPoint.x) < snapThreshold {
                snappedPoint.x = startPoint.x
            }
            if abs(point.y - startPoint.y) < snapThreshold {
                snappedPoint.y = startPoint.y
            }
            if abs(point.x - endPoint.x) < snapThreshold {
                snappedPoint.x = endPoint.x
            }
            if abs(point.y - endPoint.y) < snapThreshold {
                snappedPoint.y = endPoint.y
            }

            return snappedPoint
        }

        private func applySnappingToOtherVectors(point: CGPoint, vectorNode: SKShapeNode?) -> CGPoint {
            var snappedPoint = point

            for node in contentNode.children {
                guard let shapeNode = node as? SKShapeNode, shapeNode != vectorNode,
                      let otherPath = shapeNode.path else { continue }

                let points = getVectorEndPoints(from: otherPath)
                snappedPoint = checkSnappingToPoints(point: snappedPoint, otherStart: points.start, otherEnd: points.end)
            }

            return snappedPoint
        }

        private func getVectorEndPoints(from path: CGPath) -> (start: CGPoint, end: CGPoint) {
            return getVectorPoints(from: path)
        }

        private func checkSnappingToPoints(point: CGPoint, otherStart: CGPoint, otherEnd: CGPoint) -> CGPoint {
            var snappedPoint = point

            if abs(point.x - otherStart.x) < snapThreshold && abs(point.y - otherStart.y) < snapThreshold {
                snappedPoint = otherStart
            } else if abs(point.x - otherEnd.x) < snapThreshold && abs(point.y - otherEnd.y) < snapThreshold {
                snappedPoint = otherEnd
            }

            return snappedPoint
        }

        private func applyAngleSnapping(from anchor: CGPoint, to moving: CGPoint) -> CGPoint {
            let dx = moving.x - anchor.x
            let dy = moving.y - anchor.y

            var angle = atan2(dy, dx) * 180 / .pi
            if angle < 0 {
                angle += 360
            }

            let threshold: CGFloat = 10
            var snapped = moving

            // Горизонтальное выравнивание (0° или 180°)
            if abs(angle) < threshold || abs(angle - 180) < threshold || abs(angle + 180) < threshold {
                snapped.y = anchor.y
            }
            // Вертикальное выравнивание (90° или -90°)
            if abs(angle - 90) < threshold || abs(angle + 90) < threshold {
                snapped.x = anchor.x
            }
            // Диагональное выравнивание (45°, -45°, 135°, -135°)
            if abs(angle - 45) < threshold || abs(angle + 45) < threshold ||
                    abs(angle - 135) < threshold || abs(angle + 135) < threshold {
                let deltaX = moving.x - anchor.x
                let deltaY = moving.y - anchor.y
                let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
                let newX = anchor.x + distance * cos(45 * .pi / 180) * (deltaX > 0 ? 1 : -1)
                let newY = anchor.y + distance * sin(45 * .pi / 180) * (deltaY > 0 ? 1 : -1)
                snapped = CGPoint(x: newX, y: newY)
            }

            return snapped
        }

        private func shouldSnapToAngle(from: CGPoint, to: CGPoint) -> Bool {
            let dx = to.x - from.x
            let dy = to.y - from.y
            let angle = abs(atan2(dy, dx) * 180 / .pi)

            let threshold: CGFloat = 10
            return abs(angle - 90) < threshold ||
                   abs(angle - 180) < threshold ||
                   abs(angle) < threshold
        }
    }
