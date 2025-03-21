import SpriteKit

/**
 * CanvasScene - Основной класс для отображения и управления 2D-канвасом.
 * Обеспечивает отрисовку сетки, векторов и обработку жестов для взаимодействия.
 */
final class CanvasScene: SKScene {
        // MARK: - Properties

        /// Контейнерный узел, в который добавляются все элементы (сетка, векторы)
        /// Позволяет перемещать все содержимое канваса как единое целое
    private let contentNode = SKNode()
    private let gridNode = SKNode()

        /// Интервал между линиями сетки в точках
    private let gridSpacing: CGFloat = 30.0

        /// Порог для прилипания в точках
        /// Определяет радиус, в пределах которого точки будут "прилипать" друг к другу
    private let snapThreshold: CGFloat = 5.0

        /// Выбранный для редактирования вектор (узел)
        /// Хранит ссылку на текущий редактируемый вектор
    private var selectedVector: SKShapeNode?

        /// Менеджер для сохранения состояния векторов
    private let storageManager = StorageManager.shared

        /// Тип редактируемой точки: начальная или конечная
        /// Используется при перетаскивании точек вектора
    enum MovingPointType {
        case startPoint
        case endPoint
    }
    private var movingPointType: MovingPointType?

        // MARK: - Lifecycle Methods

    /**
     * didMove(to view: SKView)
     * Входные параметры:
     * - view: SKView - представление, в которое добавлена сцена
     * Действия:
     * 1. Вызывает setupScene() для настройки основных параметров сцены
     * 2. Вызывает setupGestures(for:) для настройки обработчиков жестов
     * Возвращает: void
     */
    override func didMove(to view: SKView) {
        setupScene()
        setupGestures(for: view)
    }

    func highLightVector(by id: UUID) {
        guard let vectorNode = contentNode.children
            .first(where: { $0.name == id.uuidString }) as? SKShapeNode else { return }

        vectorNode.lineWidth = 5.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            vectorNode.lineWidth = 2.0
        }
    }

    func removeVector(by id: UUID) {
        guard let vectorNode = contentNode.children.first(where: { $0.name == id.uuidString }) else { return }
        vectorNode.removeFromParent()
    }



    /**
     * setupScene()
     * Входные параметры: нет
     * Действия:
     * 1. Вызывает configureSceneBasics() для базовой настройки сцены
     * 2. Вызывает setupContentNode() для настройки контейнера
     * 3. Вызывает drawGrid() для отрисовки сетки
     * Возвращает: void
     */
    private func setupScene() {
        configureSceneBasics()
        setupContentNode()
        setupStaticLargeGrid()
    }

    /**
     * configureSceneBasics()
     * Входные параметры: нет
     * Действия:
     * 1. Устанавливает точку привязки в центр (0.5, 0.5)
     * 2. Устанавливает белый цвет фона
     * Возвращает: void
     */
    private func configureSceneBasics() {
            // anchorPoint определяет точку в сцене, которая совпадает с центром view
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            // Устанавливает белый цвет фона сцены
        self.backgroundColor = .white
    }

    /**
     * setupContentNode()
     * Входные параметры: нет
     * Действия:
     * 1. Добавляет contentNode как дочерний узел текущей сцены
     * 2. Устанавливает позицию contentNode в (0,0)
     * 3. Отключает пользовательское взаимодействие для contentNode
     * Возвращает: void
     */
    private func setupContentNode() {
            // Добавляем contentNode в иерархию узлов сцены
        addChild(contentNode)
        addChild(gridNode)
            // Устанавливаем начальную позицию в центр
        contentNode.position = CGPoint.zero

        gridNode.position = CGPoint.zero
        gridNode.isUserInteractionEnabled = false
    }

    /**
     * setupGestures(for view: SKView)
     * Входные параметры:
     * - view: SKView - представление, для которого настраиваются жесты
     * Действия:
     * 1. Настраивает распознаватель жеста панорамирования
     * 2. Настраивает распознаватель жеста долгого нажатия
     * Возвращает: void
     */
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

        // MARK: - Utility
    /**
     * distance(from:to:)
     * Вычисляет евклидово расстояние между двумя точками
     * Входные параметры:
     * - from: CGPoint - начальная точка
     * - to: CGPoint - конечная точка
     * Действия:
     * 1. Вычисляет разницу по X (dx)
     * 2. Вычисляет разницу по Y (dy)
     * 3. Возвращает sqrt(dx^2 + dy^2)
     * Возвращает: CGFloat - расстояние между точками
     */
    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        let dx = from.x - to.x
        let dy = from.y - to.y
        return sqrt(dx*dx + dy*dy)
    }
}
    // MARK: - Grid Drawing
/**
 * Grid Drawing Extension
 * Расширение для отрисовки сетки на канвасе.
 * Содержит методы для создания и настройки линий сетки.
 */
extension CanvasScene {
    private func setupStaticLargeGrid() {
            // Remove existing grid
        gridNode.removeAllChildren()

            // Set large grid size
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
/**
 * Vector Drawing Extension
 * Расширение для работы с векторами на канвасе.
 * Содержит методы для создания, настройки и управления векторами.
 */
extension CanvasScene {
    /**
     * addVector(vector:)
     * Входные параметры:
     * - vector: MainModel.ShowVectors.ViewModel.DisplayedVector - модель вектора
     * Действия:
     * 1. Создает линию вектора через createVectorLine
     * 2. Настраивает параметры через configureVectorLine
     * 3. Добавляет вектор на канвас
     * 4. Логирует добавление
     * Возвращает: void
     */
    func addVector(vector: MainModel.ShowVectors.ViewModel.DisplayedVector) {
        let line = createVectorLine(from: vector)
        configureVectorLine(line, with: vector)
        contentNode.addChild(line)
    }

    /**
     * createVectorLine(from:)
     * Входные параметры:
     * - vector: MainModel.ShowVectors.ViewModel.DisplayedVector - модель вектора
     * Действия:
     * 1. Создает точки начала и конца из координат вектора
     * 2. Создает SKShapeNode
     * 3. Создает путь между точками
     * Возвращает: SKShapeNode - узел с линией вектора
     */
    private func createVectorLine(from vector: MainModel.ShowVectors.ViewModel.DisplayedVector) -> SKShapeNode {
        let startPoint = CGPoint(x: vector.startX, y: vector.startY)
        let endPoint = CGPoint(x: vector.endX, y: vector.endY)

        let line = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        line.path = path
        return line
    }

    /**
     * Настраивает визуальные параметры линии вектора.
     * @param line - Узел линии для настройки
     * @param vector - Модель вектора с параметрами (цвет, id)
     */
    private func configureVectorLine(_ line: SKShapeNode, with vector: MainModel.ShowVectors.ViewModel.DisplayedVector) {
        line.strokeColor = UIColor(hexString: vector.color)
        line.lineWidth = 2.0
        line.name = "\(vector.id)"
    }
        /// Очищает содержимое contentNode и заново рисует сетку.
    func clearCanvas() {
        contentNode.removeAllChildren()
    }
}

    // MARK: - Gesture Handling

/**
 * Gesture Handling Extension
 * Расширение для обработки жестов пользователя.
 * Обрабатывает панорамирование и редактирование векторов.
 */
extension CanvasScene {
    /**
     * handlePanGesture(_:)
     * Входные параметры:
     * - gesture: UIPanGestureRecognizer - распознаватель жеста
     * Действия:
     * 1. Получает view сцены
     * 2. Получает смещение жеста
     * 3. Асинхронно обновляет позицию contentNode
     * 4. Сбрасывает смещение жеста
     * Возвращает: void
     */
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let view = self.view else { return }
        let translation = gesture.translation(in: view)
            // Обновляем позицию контейнера (contentNode)
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

    /**
     * handleLongPressGesture(_:)
     * Входные параметры:
     * - gesture: UILongPressGestureRecognizer - распознаватель жеста
     * Действия:
     * При начале жеста (.began):
     * 1. Находит вектор под точкой касания
     * 2. Определяет редактируемую точку
     * При изменении (.changed):
     * 1. Обновляет положение точки вектора
     * При завершении (.ended, .cancelled):
     * 1. Сбрасывает выбранный вектор
     * Возвращает: void
     */
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let view = self.view else { return }
        let locationInView = gesture.location(in: view)
        let sceneLocation = convertPoint(fromView: locationInView)

        switch gesture.state {
            case .began:
                    // Находим существующий узел (вектор) под касанием
                if let vectorNode = nodes(at: sceneLocation)
                    .filter({ $0.name != "grid" })
                    .compactMap({ $0 as? SKShapeNode }).first {

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
}

    // MARK: - Vector Editing Logic
extension CanvasScene {

    /**
     * detectMovingPoint(for:touchLocation:)
     * Определяет, какую точку вектора (начало или конец) перемещает пользователь
     * Входные параметры:
     * - vectorNode: SKShapeNode - узел редактируемого вектора
     * - touchLocation: CGPoint - точка касания на экране
     * Действия:
     * 1. Получает path вектора
     * 2. Извлекает ограничивающий прямоугольник (boundingBox)
     * 3. Определяет стартовую и конечную точки из прямоугольника
     * 4. Вычисляет расстояния от точки касания до обеих точек
     * 5. Возвращает тип точки на основе расстояний и порога прилипания
     * Возвращает: MovingPointType? (.startPoint или .endPoint)
     */
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

    /**
     * updateVector(vectorNode:pointType:newLocation:)
     * Обновляет положение точки вектора с учетом прилипания
     * Входные параметры:
     * - vectorNode: SKShapeNode - узел редактируемого вектора
     * - pointType: MovingPointType - тип перемещаемой точки
     * - newLocation: CGPoint - новая позиция точки
     * Действия:
     * 1. Получает текущие точки вектора
     * 2. Вычисляет новые координаты с прилипанием
     * 3. Создает новый путь
     * 4. Сохраняет изменения в хранилище
     * Возвращает: void
     */
    private func updateVector(vectorNode: SKShapeNode, pointType: MovingPointType, newLocation: CGPoint) {
        guard let path = vectorNode.path else { return }
        let points = getVectorPoints(from: path)
        let updatedPoints = calculateNewPoints(
            originalPoints: points,
            pointType: pointType,
            newLocation: newLocation,
            vectorNode: vectorNode
        )
        updateVectorPath(vectorNode: vectorNode, with: updatedPoints)
        saveVectorChanges(vectorNode: vectorNode, points: updatedPoints)
    }

    /**
     * getVectorEndPoints(from:)
     * Извлекает начальную и конечную точки вектора из его пути
     * Входные параметры:
     * - path: CGPath - путь вектора
     * Действия:
     * 1. Получает ограничивающий прямоугольник пути
     * 2. Создает точки из минимальных и максимальных координат
     * Возвращает: (start: CGPoint, end: CGPoint) - кортеж с точками
     */
    private func getVectorPoints(from path: CGPath) -> (start: CGPoint, end: CGPoint) {
        let bbox = path.boundingBox
        return (
            start: CGPoint(x: bbox.minX, y: bbox.minY),
            end: CGPoint(x: bbox.maxX, y: bbox.maxY)
        )
    }

    /**
     * calculateNewPoints(originalPoints:pointType:newLocation:vectorNode:)
     * Входные параметры:
     * - originalPoints: (start: CGPoint, end: CGPoint) - исходные точки вектора
     * - pointType: MovingPointType - тип перемещаемой точки
     * - newLocation: CGPoint - новые координаты точки
     * - vectorNode: SKShapeNode - узел редактируемого вектора
     * Действия:
     * 1. Применяет снаппинг к новой позиции
     * 2. В зависимости от типа точки:
     *    - Для startPoint: применяет угловой снаппинг относительно конечной точки
     *    - Для endPoint: применяет угловой снаппинг относительно начальной точки
     * Возвращает: (start: CGPoint, end: CGPoint) - обновленные точки вектора
     */
    private func calculateNewPoints(originalPoints: (start: CGPoint, end: CGPoint),
                                    pointType: MovingPointType, newLocation: CGPoint,
                                    vectorNode: SKShapeNode) -> (start: CGPoint, end: CGPoint) {

        let snappedLocation = applySnapping(to: newLocation, startPoint: originalPoints.start,
                                            endPoint: originalPoints.end, vectorNode: vectorNode)

        var newStart = originalPoints.start
        var newEnd = originalPoints.end

        switch pointType {
            case .startPoint:
                newStart = applyAngleSnapping(from: originalPoints.end, to: snappedLocation)
            case .endPoint:
                newEnd = applyAngleSnapping(from: originalPoints.start, to: snappedLocation)
        }

        return (start: newStart, end: newEnd)
    }

    /**
     * updateVectorPath(vectorNode:with:)
     * Входные параметры:
     * - vectorNode: SKShapeNode - узел вектора для обновления
     * - points: (start: CGPoint, end: CGPoint) - новые точки вектора
     * Действия:
     * 1. Создает новый изменяемый путь
     * 2. Добавляет линию от начальной до конечной точки
     * 3. Обновляет путь узла
     * Возвращает: void
     */
    private func updateVectorPath(vectorNode: SKShapeNode, with points: (start: CGPoint, end: CGPoint)) {
        let mutablePath = CGMutablePath()
        mutablePath.move(to: points.start)
        mutablePath.addLine(to: points.end)
        vectorNode.path = mutablePath
    }

    /**
     * saveVectorChanges(vectorNode:points:)
     * Входные параметры:
     * - vectorNode: SKShapeNode - узел вектора
     * - points: (start: CGPoint, end: CGPoint) - точки вектора
     * Действия:
     * 1. Извлекает UUID вектора из его имени
     * 2. Вызывает метод обновления в storageManager
     * 3. Обрабатывает результат обновления
     * Возвращает: void
     */
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

    /**
     * handleVectorUpdateResult(_:)
     * Входные параметры:
     * - result: Result<Void, Error> - результат операции обновления
     * Действия:
     * 1. При успехе: выводит сообщение об успешном сохранении
     * 2. При ошибке: выводит сообщение об ошибке
     * Возвращает: void
     */
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
    /**
     * applySnapping(to:startPoint:endPoint:vectorNode:)
     * Применяет логику прилипания к точке
     * Входные параметры:
     * - point: CGPoint - исходная точка
     * - startPoint: CGPoint - начальная точка вектора
     * - endPoint: CGPoint - конечная точка вектора
     * - vectorNode: SKShapeNode? - текущий редактируемый вектор
     * Действия:
     * 1. Проверяет прилипание к собственным точкам вектора
     * 2. Проверяет прилипание к точкам других векторов
     * Возвращает: CGPoint - новая позиция с учетом прилипания
     */
    private func applySnapping(to point: CGPoint, startPoint: CGPoint, endPoint: CGPoint, vectorNode: SKShapeNode?) -> CGPoint {
        var snappedPoint = point
        snappedPoint = applySnappingToOwnPoints(point: snappedPoint, startPoint: startPoint, endPoint: endPoint) // Применяем прилипание к собственным точкам
        snappedPoint = applySnappingToOtherVectors(point: snappedPoint, vectorNode: vectorNode) // Применяем прилипание к точкам других векторов

        return snappedPoint
    }

    /**
     * applyAngleSnapping(from:to:)
     * Применяет выравнивание по углам (0° или 90°)
     * Входные параметры:
     * - anchor: CGPoint - неподвижная точка вектора
     * - moving: CGPoint - перемещаемая точка
     * Действия:
     * 1. Вычисляет угол между точками
     * 2. Если угол близок к 0° или 180° - выравнивает горизонтально
     * 3. Если угол близок к 90° или -90° - выравнивает вертикально
     * Возвращает: CGPoint - выровненная позиция
     */
    private func applySnappingToOwnPoints(point: CGPoint, startPoint: CGPoint, endPoint: CGPoint) -> CGPoint {
        var snappedPoint = point

        if abs(point.x - startPoint.x) < snapThreshold { // Прилипание по X к начальной точке
            snappedPoint.x = startPoint.x
        }

        if abs(point.y - startPoint.y) < snapThreshold { // Прилипание по Y к начальной точке
            snappedPoint.y = startPoint.y
        }

        if abs(point.x - endPoint.x) < snapThreshold { // Прилипание по X к конечной точке
            snappedPoint.x = endPoint.x
        }

        if abs(point.y - endPoint.y) < snapThreshold { // Прилипание по Y к конечной точке
            snappedPoint.y = endPoint.y
        }

        return snappedPoint
    }

    /**
     * applySnappingToOtherVectors(point:vectorNode:)
     * Проверяет прилипание к точкам других векторов
     * Входные параметры:
     * - point: CGPoint - текущая точка
     * - vectorNode: SKShapeNode? - текущий редактируемый вектор
     * Действия:
     * 1. Перебирает все векторы в contentNode
     * 2. Для каждого вектора (кроме текущего):
     *    - Получает его конечные точки
     *    - Проверяет необходимость прилипания
     * Возвращает: CGPoint - точка после прилипания
     */
    private func applySnappingToOtherVectors(point: CGPoint, vectorNode: SKShapeNode?) -> CGPoint {
        var snappedPoint = point

            // Перебираем все узлы в contentNode
        for node in contentNode.children {
                // Проверяем, что узел - это вектор и не является текущим
            guard let shapeNode = node as? SKShapeNode, shapeNode != vectorNode,
                  let otherPath = shapeNode.path else { continue }

                // Получаем точки другого вектора
            let points = getVectorEndPoints(from: otherPath)
                // Проверяем прилипание к точкам
            snappedPoint = checkSnappingToPoints(point: snappedPoint, otherStart: points.start, otherEnd: points.end)
        }

        return snappedPoint
    }

    /**
     * getVectorEndPoints(from:)
     * Извлекает конечные точки вектора из его пути
     * Входные параметры:
     * - path: CGPath - путь вектора
     * Действия:
     * 1. Получает ограничивающий прямоугольник пути
     * 2. Создает точки из его границ
     * Возвращает: (start: CGPoint, end: CGPoint)
     */
    private func getVectorEndPoints(from path: CGPath) -> (start: CGPoint, end: CGPoint) {
            // Получаем ограничивающий прямоугольник пути
        let bbox = path.boundingBox
            // Возвращаем точки из минимальных и максимальных координат
        return (
            start: CGPoint(x: bbox.minX, y: bbox.minY),
            end: CGPoint(x: bbox.maxX, y: bbox.maxY)
        )
    }

    /**
     * checkSnappingToPoints(point:otherStart:otherEnd:)
     * Проверяет необходимость прилипания точки к другим точкам
     * Входные параметры:
     * - point: CGPoint - проверяемая точка
     * - otherStart: CGPoint - начальная точка другого вектора
     * - otherEnd: CGPoint - конечная точка другого вектора
     * Действия:
     * 1. Проверяет расстояние до начальной точки
     * 2. Если меньше порога - прилипает к ней
     * 3. Проверяет расстояние до конечной точки
     * 4. Если меньше порога - прилипает к ней
     * Возвращает: CGPoint - точка после прилипания
     */

    /**
     abs - это функция в Swift, которая возвращает абсолютное значение числа
     (то есть, положительное значение числа без знака). Например:

     abs(-5) -> 5
     abs(5) -> 5

     В контексте вашего кода abs используется для сравнения расстояний между точками.
     Когда мы проверяем расстояние между точками, нам важна только величина разницы,
     а не её знак (положительная или отрицательная).

     Например, в методе applySnappingToOwnPoints:
     abs(point.x - startPoint.x) < snapThreshold

     Это проверяет, находится ли точка в пределах порога прилипания (snapThreshold)
     от начальной точки, независимо от того, слева или справа от неё расположена проверяемая точка.

     */
    private func checkSnappingToPoints(point: CGPoint, otherStart: CGPoint, otherEnd: CGPoint) -> CGPoint {
        var snappedPoint = point

        if abs(point.x - otherStart.x) < snapThreshold && abs(point.y - otherStart.y) < snapThreshold {
            snappedPoint = otherStart
        } else if abs(point.x - otherEnd.x) < snapThreshold && abs(point.y - otherEnd.y) < snapThreshold {
            snappedPoint = otherEnd
        }

        return snappedPoint
    }

    /**
     * applyAngleSnapping(from:to:)
     * Применяет выравнивание по углам (0° или 90°)
     * Входные параметры:
     * - anchor: CGPoint - неподвижная точка вектора
     * - moving: CGPoint - перемещаемая точка
     * Действия:
     * 1. Вычисляет угол между точками
     * 2. Если угол близок к 0° или 180° - выравнивает горизонтально
     * 3. Если угол близок к 90° или -90° - выравнивает вертикально
     * Возвращает: CGPoint - новая позиция после выравнивания
     */
    private func applyAngleSnapping(from anchor: CGPoint, to moving: CGPoint) -> CGPoint {
            // Вычисляем разницу координат
        let dx = moving.x - anchor.x
        let dy = moving.y - anchor.y

            // Вычисляем угол в градусах
        var angle = atan2(dy, dx) * 180 / .pi
        if angle < 0 {
            angle += 360
        }

            // Порог отклонения для срабатывания выравнивания
        let threshold: CGFloat = 10

        var snapped = moving
            // Горизонтальное выравнивание: если угол близок к 0° или 180°.
        if abs(angle) < threshold || abs(angle - 180) < threshold || abs(angle + 180) < threshold {
            snapped.y = anchor.y
        }
            // Вертикальное выравнивание: если угол близок к 90° или -90°.
        else if abs(angle - 90) < threshold || abs(angle + 90) < threshold  {
            snapped.x = anchor.x
        }
        return snapped
    }


}
