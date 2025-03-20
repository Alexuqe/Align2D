import SpriteKit

//class CanvasScene: SKScene {
//
//    // MARK: - Properties
//
//    /// Интервал между линиями сетки.
//    private let gridSpacing: CGFloat = 50.0
//
//    /// Порог прилипания (в точках).
//    private let snapThreshold: CGFloat = 10.0
//
//    /// Текущий выбранный для редактирования вектор (узел).
//    private var selectedVector: SKShapeNode?
//
//    /// Тип перемещаемой точки: начальная или конечная.
//    enum MovingPointType {
//        case startPoint
//        case endPoint
//    }
//    private var movingPointType: MovingPointType?
//    private var storageManager = StorageManager.shared
//
//    // MARK: - Lifecycle
//
//    override func didMove(to view: SKView) {
//        // Устанавливаем anchorPoint, чтобы центр сцены был (0,0)
//        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        self.backgroundColor = .white
//
//        // Рисуем сетку
//        drawGrid()
//
//        // Добавляем панорамирующий жест (перемещение полотна)
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
//        view.addGestureRecognizer(panGesture)
//
//        // Добавляем жест для редактирования векторов (долгое нажатие)
//        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
//        view.addGestureRecognizer(longPressGesture)
//    }
//
//    // MARK: - Grid Drawing
//
//    /// Рисует сетку по всей сцене с учетом anchorPoint = (0.5, 0.5).
//    private func drawGrid() {
//        let halfWidth = size.width / 2.0
//        let halfHeight = size.height / 2.0
//
//        // Вертикальные линии: от -halfWidth до +halfWidth
//        let numberOfVerticalLines = Int(size.width / gridSpacing)
//        for i in 0...numberOfVerticalLines {
//            let x = -halfWidth + CGFloat(i) * gridSpacing
//            let path = CGMutablePath()
//            path.move(to: CGPoint(x: x, y: -halfHeight))
//            path.addLine(to: CGPoint(x: x, y: halfHeight))
//
//            let line = SKShapeNode(path: path)
//            line.strokeColor = .lightGray
//            line.lineWidth = 0.5
//            line.zPosition = -1  // чтобы сетка была позади прочих элементов
//            addChild(line)
//        }
//
//        // Горизонтальные линии: от -halfHeight до +halfHeight
//        let numberOfHorizontalLines = Int(size.height / gridSpacing)
//        for i in 0...numberOfHorizontalLines {
//            let y = -halfHeight + CGFloat(i) * gridSpacing
//            let path = CGMutablePath()
//            path.move(to: CGPoint(x: -halfWidth, y: y))
//            path.addLine(to: CGPoint(x: halfWidth, y: y))
//
//            let line = SKShapeNode(path: path)
//            line.strokeColor = .lightGray
//            line.lineWidth = 0.5
//            line.zPosition = -1
//            addChild(line)
//        }
//    }
//
//    // MARK: - Vector Drawing
//
//    /// Отрисовывает вектор на сцене согласно данным вектора.
//    /// Предполагается, что координаты вектора уже соответствуют системе координат сцены.
//    func addVector(vector: MainModel.ShowVectors.ViewModel.DisplayedVector) {
//        let startPoint = CGPoint(x: vector.startX, y: vector.startY)
//        let endPoint   = CGPoint(x: vector.endX, y: vector.endY)
//
//        let line = SKShapeNode()
//        let path = CGMutablePath()
//        path.move(to: startPoint)
//        path.addLine(to: endPoint)
//
//        line.path = path
//        line.strokeColor = vector.color
//        line.lineWidth = 2.0
//        line.name = "\(vector.id)" // используем ID вектора для поиска
//        addChild(line)
//
//        print("Добавлена линия: start: \(startPoint) end: \(endPoint)")
//    }
//
//    /// Удаляет все дочерние узлы и заново рисует сетку.
//    func clearCanvas() {
//        removeAllChildren()
//        drawGrid()
//    }
//
//    // MARK: - Gesture Handling
//
//    /// Обработка панорамирующего жеста – перемещает всю сцену.
//    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
//        guard let view = self.view else { return }
//        let translation = gesture.translation(in: view)
//        DispatchQueue.main.async {
//            self.position = CGPoint(x: self.position.x + translation.x, y: self.position.y - translation.y)
//            gesture.setTranslation(.zero, in: view)
//        }
//    }
//
//    /// Обработка долгого нажатия для редактирования вектора.
//    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
//        guard let view = self.view else { return }
//        let locationInView = gesture.location(in: view)
//        let sceneLocation = convertPoint(fromView: locationInView)
//
//        switch gesture.state {
//        case .began:
//            if let vectorNode = nodes(at: sceneLocation).compactMap({ $0 as? SKShapeNode }).first {
//                selectedVector = vectorNode
//                movingPointType = detectMovingPoint(for: vectorNode, touchLocation: sceneLocation)
//            }
//        case .changed:
//            guard let vectorNode = selectedVector, let pointType = movingPointType else { return }
//            DispatchQueue.main.async {
//                self.updateVector(vectorNode: vectorNode, pointType: pointType, newLocation: sceneLocation)
//            }
//        case .ended, .cancelled:
//            selectedVector = nil
//            movingPointType = nil
//        default:
//            break
//        }
//    }
//
//    // MARK: - Vector Editing Logic
//
//    /// Определяет, какую точку вектора (начальную или конечную) пользователь собирается переместить.
//    private func detectMovingPoint(for vectorNode: SKShapeNode, touchLocation: CGPoint) -> MovingPointType? {
//        guard let path = vectorNode.path else { return nil }
//        let bbox = path.boundingBox
//        let startPoint = CGPoint(x: bbox.minX, y: bbox.minY)
//        let endPoint   = CGPoint(x: bbox.maxX, y: bbox.maxY)
//
//        let distanceToStart = distance(from: touchLocation, to: startPoint)
//        let distanceToEnd   = distance(from: touchLocation, to: endPoint)
//        if distanceToStart <= distanceToEnd && distanceToStart < snapThreshold {
//            return .startPoint
//        } else if distanceToEnd < distanceToStart && distanceToEnd < snapThreshold {
//            return .endPoint
//        } else {
//            return distanceToStart < distanceToEnd ? .startPoint : .endPoint
//        }
//    }
//
//    /// Обновляет узел вектора с новым положением редактируемой точки, учитывая логику прилипания и угол-снаппинг.
//    private func updateVector(vectorNode: SKShapeNode, pointType: MovingPointType, newLocation: CGPoint) {
//        guard let path = vectorNode.path else { return }
//        let mutablePath = CGMutablePath()
//
//        // Получаем исходные точки вектора через boundingBox (простейшая логика для прямой линии)
//        let bbox = path.boundingBox
//        let originalStart = CGPoint(x: bbox.minX, y: bbox.minY)
//        let originalEnd   = CGPoint(x: bbox.maxX, y: bbox.maxY)
//
//        var newStartPoint = originalStart
//        var newEndPoint = originalEnd
//
//        // Применяем базовую логику прилипания к точке
//        let snappedLocation = applySnapping(to: newLocation, startPoint: originalStart, endPoint: originalEnd, vectorNode: vectorNode)
//
//        // Применяем дополнительно логику угол-снаппинга:
//        // Если редактируется конечная точка, используем оригинальную начальную точку как якорь,
//        // Если редактируется начальная точка, используем оригинальную конечную точку как якорь.
//        if pointType == .endPoint {
//            newEndPoint = applyAngleSnapping(from: originalStart, to: snappedLocation)
//        } else if pointType == .startPoint {
//            newStartPoint = applyAngleSnapping(from: originalEnd, to: snappedLocation)
//        }
//
//        mutablePath.move(to: newStartPoint)
//        mutablePath.addLine(to: newEndPoint)
//        vectorNode.path = mutablePath
//
//        // Сохраняем изменения в Core Data
//        if let vectorID = vectorNode.name, let uuid = UUID(uuidString: vectorID) {
//            storageManager.updateVector(
//                id: uuid,
//                startX: Double(newStartPoint.x),
//                startY: Double(newStartPoint.y),
//                endX: Double(newEndPoint.x),
//                endY: Double(newEndPoint.y)
//            ) { result in
//                switch result {
//                case .success:
//                    print("Изменения вектора (с угол-снаппингом) сохранены")
//                case .failure(let error):
//                    print("Ошибка при сохранении изменений: \(error)")
//                }
//            }
//        }
//    }
//
//    // MARK: - Snapping & Angle Snapping
//
//    /// Применяет базовую логику прилипания к точке.
//    private func applySnapping(to point: CGPoint, startPoint: CGPoint, endPoint: CGPoint, vectorNode: SKShapeNode?) -> CGPoint {
//        var snappedPoint = point
//
//        // 1. Прилипание к собственным крайним точкам.
//        if abs(point.x - startPoint.x) < snapThreshold {
//            snappedPoint.x = startPoint.x
//        }
//        if abs(point.y - startPoint.y) < snapThreshold {
//            snappedPoint.y = startPoint.y
//        }
//        if abs(point.x - endPoint.x) < snapThreshold {
//            snappedPoint.x = endPoint.x
//        }
//        if abs(point.y - endPoint.y) < snapThreshold {
//            snappedPoint.y = endPoint.y
//        }
//
//        // 2. Прилипание к точкам других векторов.
//        for node in self.children {
//            guard let shapeNode = node as? SKShapeNode,
//                  shapeNode != vectorNode,
//                  let otherPath = shapeNode.path else { continue }
//
//            let otherBBox = otherPath.boundingBox
//            let otherStart = CGPoint(x: otherBBox.minX, y: otherBBox.minY)
//            let otherEnd   = CGPoint(x: otherBBox.maxX, y: otherBBox.maxY)
//
//            if abs(point.x - otherStart.x) < snapThreshold && abs(point.y - otherStart.y) < snapThreshold {
//                snappedPoint = otherStart
//            }
//            if abs(point.x - otherEnd.x) < snapThreshold && abs(point.y - otherEnd.y) < snapThreshold {
//                snappedPoint = otherEnd
//            }
//        }
//
//        return snappedPoint
//    }
//
//    /// Применяет угол-снаппинг: если угол между якорем и редактируемой точкой близок к 0° или 90°,
//    /// точка корректируется так, чтобы обеспечить идеально горизонтальное или вертикальное выравнивание.
//    private func applyAngleSnapping(from anchor: CGPoint, to moving: CGPoint) -> CGPoint {
//        let dx = moving.x - anchor.x
//        let dy = moving.y - anchor.y
//
//        // Вычисляем угол в градусах.
//        let angle = atan2(dy, dx)
//        let angleDegrees = angle * 180 / .pi
//
//        let threshold: CGFloat = 10.0  // Порог отклонения в градусах
//
//        var snapped = moving
//
//        // Если угол близок к 0° (или 180°) → горизонтальное выравнивание.
//        if abs(angleDegrees) < threshold || abs(angleDegrees - 180) < threshold || abs(angleDegrees + 180) < threshold {
//            snapped.y = anchor.y
//        }
//        // Если угол близок к 90° или -90° → вертикальное выравнивание.
//        else if abs(angleDegrees - 90) < threshold || abs(angleDegrees + 90) < threshold {
//            snapped.x = anchor.x
//        }
//
//        return snapped
//    }
//
//    // MARK: - Utility
//
//    /// Вычисляет евклидово расстояние между двумя точками.
//    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
//        let dx = from.x - to.x
//        let dy = from.y - to.y
//        return sqrt(dx * dx + dy * dy)
//    }
//}


class CanvasScene: SKScene {

    // MARK: - Properties

    /// Контейнерный узел, в который добавляются все элементы (сетка, векторы)
    private let contentNode = SKNode()

    /// Интервал между линиями сетки
    private let gridSpacing: CGFloat = 50.0

    /// Порог для прилипания (в точках)
    private let snapThreshold: CGFloat = 10.0

    /// Выбранный для редактирования вектор (узел)
    private var selectedVector: SKShapeNode?
    private let storageManager = StorageManager.shared

    /// Тип редактируемой точки: начальная или конечная
    enum MovingPointType {
        case startPoint
        case endPoint
    }
    private var movingPointType: MovingPointType?

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        // Устанавливаем anchorPoint, чтобы центр сцены был (0,0)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = .white

        // Добавляем контейнер для всего содержимого
        addChild(contentNode)
        contentNode.position = CGPoint.zero
        contentNode.isUserInteractionEnabled = false

        // Рисуем сетку в контейнере
        drawGrid()

        // Добавляем жесты: панорамирование полотна и редактирование векторов
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        view.addGestureRecognizer(longPressGesture)
    }

    // MARK: - Grid Drawing

    /// Рисует сетку в контейнерном узле (contentNode).
    private func drawGrid() {
        let halfWidth = size.width / 2.0
        let halfHeight = size.height / 2.0

        let numberOfVerticalLines = Int(size.width / gridSpacing)
        for line in 0...numberOfVerticalLines {
            let x = -halfWidth + CGFloat(line) * gridSpacing
            let path = CGMutablePath()
            path.move(to: CGPoint(x: x, y: -halfHeight))
            path.addLine(to: CGPoint(x: x, y: halfHeight))
            let line = SKShapeNode(path: path)
            line.strokeColor = .lightGray
            line.lineWidth = 0.5
            line.zPosition = -1  // Сетка рисуется позади
            contentNode.isUserInteractionEnabled = false
            contentNode.addChild(line)
        }

        let numberOfHorizontalLines = Int(size.height / gridSpacing)
        for line in 0...numberOfHorizontalLines {
            let y = -halfHeight + CGFloat(line) * gridSpacing
            let path = CGMutablePath()
            path.move(to: CGPoint(x: -halfWidth, y: y))
            path.addLine(to: CGPoint(x: halfWidth, y: y))
            let line = SKShapeNode(path: path)
            line.strokeColor = .lightGray
            line.lineWidth = 0.5
            line.zPosition = -1
            contentNode.isUserInteractionEnabled = false
            contentNode.addChild(line)
        }
    }

    // MARK: - Vector Drawing

    /// Отрисовывает вектор на поле, добавляя его в contentNode.
    func addVector(vector: MainModel.ShowVectors.ViewModel.DisplayedVector) {
        let startPoint = CGPoint(x: vector.startX, y: vector.startY)
        let endPoint = CGPoint(x: vector.endX, y: vector.endY)

        let line = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)

        line.path = path
        line.strokeColor = UIColor(hexString: vector.color)
        line.lineWidth = 2.0
        line.name = "\(vector.id)"  // Используется для идентификации вектора
        addChild(line)

        print("Добавлена линия: start: \(startPoint) end: \(endPoint)")
    }

    /// Очищает содержимое contentNode и заново рисует сетку.
    func clearCanvas() {
        contentNode.removeAllChildren()
        drawGrid()
    }

    // MARK: - Gesture Handling

    /// Панорамирование: перемещает containerNode (contentNode) относительно сцены.
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let view = self.view else { return }
        let translation = gesture.translation(in: view)
        // Обновляем позицию контейнера (contentNode)
        DispatchQueue.main.async {
            self.contentNode.position = CGPoint(
                x: self.contentNode.position.x + translation.x,
                y: self.contentNode.position.y - translation.y
            )
            gesture.setTranslation(.zero, in: view)
        }
    }

    /// Обработка долгого нажатия для редактирования векторов.
//    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
//        guard let view = self.view else { return }
//        let locationInView = gesture.location(in: view)
//        let sceneLocation = convertPoint(fromView: locationInView)
//
//        switch gesture.state {
//        case .began:
//            if let vectorNode = nodes(at: sceneLocation).compactMap({ $0 as? SKShapeNode }).first {
//                selectedVector = vectorNode
//                movingPointType = detectMovingPoint(for: vectorNode, touchLocation: sceneLocation)
//            }
//        case .changed:
//            guard let vectorNode = selectedVector, let pointType = movingPointType else { return }
//            DispatchQueue.main.async {
//                self.updateVector(vectorNode: vectorNode, pointType: pointType, newLocation: sceneLocation)
//            }
//        case .ended, .cancelled:
//            selectedVector = nil
//            movingPointType = nil
//        default:
//            break
//        }
//    }

    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let view = self.view else { return }
        let locationInView = gesture.location(in: view)
        let sceneLocation = convertPoint(fromView: locationInView)

        switch gesture.state {
        case .began:
            // Находим существующий узел (вектор) под касанием
            if let vectorNode = nodes(at: sceneLocation).compactMap({ $0 as? SKShapeNode }).first {
                selectedVector = vectorNode
                movingPointType = detectMovingPoint(for: vectorNode, touchLocation: sceneLocation)
            }
        case .changed:
            guard let vectorNode = selectedVector, let pointType = movingPointType else { return }
            // Обновляем путь узла, не создавая новый
            DispatchQueue.main.async {
                self.updateVector(vectorNode: vectorNode, pointType: pointType, newLocation: sceneLocation)
            }
        case .ended, .cancelled:
            selectedVector = nil
            movingPointType = nil
        default:
            break
        }
    }


    // MARK: - Vector Editing Logic

    /// Определяет, какую точку вектора (начало или конец) перемещает пользователь.
    private func detectMovingPoint(for vectorNode: SKShapeNode, touchLocation: CGPoint) -> MovingPointType? {
        guard let path = vectorNode.path else { return nil }
        let bbox = path.boundingBox
        let startPoint = CGPoint(x: bbox.minX, y: bbox.minY)
        let endPoint = CGPoint(x: bbox.maxX, y: bbox.maxY)

        let distanceToStart = distance(from: touchLocation, to: startPoint)
        let distanceToEnd = distance(from: touchLocation, to: endPoint)

        if distanceToStart <= distanceToEnd && distanceToStart < snapThreshold {
            return .startPoint
        } else if distanceToEnd < distanceToStart && distanceToEnd < snapThreshold {
            return .endPoint
        } else {
            return distanceToStart < distanceToEnd ? .startPoint : .endPoint
        }
    }

    /// Обновляет путь вектора при редактировании с логикой прилипания и угол-снаппинга.
    private func updateVector(vectorNode: SKShapeNode, pointType: MovingPointType, newLocation: CGPoint) {
        guard let path = vectorNode.path else { return }
        let mutablePath = CGMutablePath()

        let bbox = path.boundingBox
        let originalStart = CGPoint(x: bbox.minX, y: bbox.minY)
        let originalEnd = CGPoint(x: bbox.maxX, y: bbox.maxY)

        var newStartPoint = originalStart
        var newEndPoint = originalEnd

        // Применяем базовую логику прилипания
        let snappedLocation = applySnapping(to: newLocation, startPoint: originalStart, endPoint: originalEnd, vectorNode: vectorNode)

        // Применяем процедуру угол-снаппинга:
        if pointType == .endPoint {
            newEndPoint = applyAngleSnapping(from: originalStart, to: snappedLocation)
        } else if pointType == .startPoint {
            newStartPoint = applyAngleSnapping(from: originalEnd, to: snappedLocation)
        }

        mutablePath.move(to: newStartPoint)
        mutablePath.addLine(to: newEndPoint)
        vectorNode.path = mutablePath

        // Сохраняем изменённые координаты в Core Data через уведомление родительского уровня
        if let vectorIDString = vectorNode.name, let uuid = UUID(uuidString: vectorIDString) {
            storageManager.updateVector(
                id: uuid,
                startX: Double(newStartPoint.x),
                startY: Double(newStartPoint.y),
                endX: Double(newEndPoint.x),
                endY: Double(newEndPoint.y)
            ) { result in
                switch result {
                case .success:
                    print("Изменения вектора успешно сохранены")
                case .failure(let error):
                    print("Ошибка при сохранении изменений: \(error)")
                }
            }
        }
    }

    // MARK: - Snapping & Angle Snapping

    /// Применяет базовую логику прилипания: если точка близка к старту/концу текущего вектора или к точкам других векторов.
    private func applySnapping(to point: CGPoint, startPoint: CGPoint, endPoint: CGPoint, vectorNode: SKShapeNode?) -> CGPoint {
        var snappedPoint = point

        // Прилипание к собственной начальной/конечной точке
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

        // Прилипание к точкам других векторов
        for node in contentNode.children {
            guard let shapeNode = node as? SKShapeNode,
                  shapeNode != vectorNode,
                  let otherPath = shapeNode.path else { continue }
            let otherBBox = otherPath.boundingBox
            let otherStart = CGPoint(x: otherBBox.minX, y: otherBBox.minY)
            let otherEnd = CGPoint(x: otherBBox.maxX, y: otherBBox.maxY)

            if abs(point.x - otherStart.x) < snapThreshold && abs(point.y - otherStart.y) < snapThreshold {
                snappedPoint = otherStart
            } else if abs(point.x - otherEnd.x) < snapThreshold && abs(point.y - otherEnd.y) < snapThreshold {
                snappedPoint = otherEnd
            }
        }
        return snappedPoint
    }

    /// Применяет угол-снаппинг: если угол между якорной точкой и редактируемой точкой близок к 0° или 90°, корректирует координаты для выравнивания.
    private func applyAngleSnapping(from anchor: CGPoint, to moving: CGPoint) -> CGPoint {
        let dx = moving.x - anchor.x
        let dy = moving.y - anchor.y
        let angle = atan2(dy, dx) * 180 / .pi  // угол в градусах
        let threshold: CGFloat = 10.0  // порог отклонения в градусах

        var snapped = moving
        // Горизонтальное выравнивание: если угол близок к 0° или 180°.
        if abs(angle) < threshold || abs(angle - 180) < threshold || abs(angle + 180) < threshold {
            snapped.y = anchor.y
        }
        // Вертикальное выравнивание: если угол близок к 90° или -90°.
        else if abs(angle - 90) < threshold || abs(angle + 90) < threshold {
            snapped.x = anchor.x
        }
        return snapped
    }

    // MARK: - Utility

    /// Вычисляет евклидово расстояние между двумя точками.
    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        let dx = from.x - to.x
        let dy = from.y - to.y
        return sqrt(dx*dx + dy*dy)
    }
}
