//    //
//    //  CanvasScene.swift
//    //  Align2D
//    //
//    //  Created by Sasha on 18.03.25.
//    //
//
//import SpriteKit
//import UIKit
//
//enum MovingPointType { // Тип точек для определения, какая из них перемещается
//    case startPonit
//    case endPoint
//}
//
//final class CanvasScene: SKScene {
//
//        //MARK: Properties
//    private var selectedVector: SKShapeNode? // Текущий вектор
//    private var movingPointType: MovingPointType?
//    private let snapPointThresgold: CGFloat = 10.0
//
//        //MARK: Life Cycle
//    override func didMove(to view: SKView) {
//        self.backgroundColor = .systemGray6
//        self.scaleMode = .aspectFit
//        self.yScale = -1
//
//        view.isUserInteractionEnabled = true
//        view.isMultipleTouchEnabled = true
//
//        createPanGesture()
//        createLongPressGesture()
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//    }
//
//    private func distance(from: CGPoint, to: CGPoint) -> CGFloat { // Расстояние между двумя точками
//        return sqrt(pow(from.x - to.x, 2) + pow(from.y - to.y, 2))
//    }
//}
//
//    //MARK: - Vector Methods
//extension CanvasScene {
//
//    func addVector(vector: MainModel.ShowVectors.ViewModel.DisplayedVector) {  // Добавление нового вектора
//        let scaleFactor: CGFloat = 50.0
//
//        let startPoint = CGPoint(
//            x: vector.startX * scaleFactor + frame.width / 2,
//            y: vector.startY * scaleFactor
//        )
//
//        let endPoint = CGPoint(
//            x: vector.endX * scaleFactor + frame.width / 2,
//            y: vector.endY * scaleFactor + frame.width / 2
//        )
//
//        let path = CGMutablePath()
//        path.move(to: startPoint)
//        path.addLine(to: endPoint)
//
//        let line = SKShapeNode(path: path)
//        line.strokeColor = vector.color
//        line.lineWidth = 2
//        line.name = "\(vector.id)"
//        addChild(line)
//
//        print("Vector added to scene at: start(\(startPoint)), end(\(endPoint))")
//    }
//
//    func clearCanvas() {   // Очистка полотна
//        removeAllChildren()
//        print("Canvas cleared")
//    }
//}
//
//    //MARK: - Setup Gesture
//private extension CanvasScene {
//
//    func createPanGesture() { // Жест для перемещения полотна
//        let panGesture = UIPanGestureRecognizer(
//            target: self,
//            action: #selector(handlePanGesture))
//
//        panGesture.isEnabled = true
//        panGesture.delegate = self
//        view?.addGestureRecognizer(panGesture)
//        print("Pan gesture created and enabled")
//    }
//
//    func createLongPressGesture() {
//        let longPressGesture = UILongPressGestureRecognizer(
//            target: self,
//            action: #selector(handleLongPressGesture))
//        longPressGesture.isEnabled = true
//        longPressGesture.delegate = self
//        view?.addGestureRecognizer(longPressGesture)
//        print("Long gesture created and enabled")
//    }
//
//
//        //MARK: - Actions
//    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) { // Перемещение полотна
//        guard let view = self.view else { return }
//
//        let translation = gesture.translation(in: view)
//        self.position = CGPoint(
//            x: self.position.x + translation.x,
//            y: self.position.y - translation.y)
//
//        print("Pan translation: \(translation)")
//
//        gesture.setTranslation(.zero, in: view)
//    }
//
//    @objc func handleLongPressGesture(gesture: UILongPressGestureRecognizer) { // Редактирование вектора
//        let location = gesture.location(in: self.view)
//        let sceneLocation = convertPoint(toView: location)
//
//        switch gesture.state {
//            case .began:
//                beganState(sceneLocation: sceneLocation)
//            case .changed:
//                changedState(newLocation: sceneLocation)
//            case .ended, .cancelled:
//                selectedVector = nil
//                movingPointType = nil
//            default:
//                break
//        }
//    }
//
//        // MARK: - Логика редактирования векторов
//    func detectMovingPoint(for vectorNode: SKShapeNode, touchLocation: CGPoint) -> MovingPointType? {  // Определение, какую точку перемещает пользователь
//        guard let path = vectorNode.path else { return nil }
//
//        let startPoint = path.currentPoint
//        let endPoint = CGPoint(x: path.boundingBox.maxX, y: path.boundingBox.maxY)
//
//        if distance(from: touchLocation, to: startPoint) < snapPointThresgold {
//            return .startPonit
//        } else if distance(from: touchLocation, to: endPoint) < snapPointThresgold {
//            return .endPoint
//        }
//
//        return nil
//    }
//
//    func updateVector(vectorNode: SKShapeNode, pointType: MovingPointType, newLocation: CGPoint) { // Обновление координат вектора
//        guard let path = vectorNode.path else { return }
//
//        let mutablePath = path.mutableCopy()
//        let startPoint = path.currentPoint
//        let endPoint = CGPoint(x: path.boundingBox.maxX, y: path.boundingBox.maxX)
//        let snappedLocation = applySnapping(to: newLocation)
//
//        switch pointType {
//            case .startPonit:
//                mutablePath?.move(to: snappedLocation)
//                mutablePath?.addLine(to: endPoint)
//            case .endPoint:
//                mutablePath?.move(to: startPoint)
//                mutablePath?.addLine(to: snappedLocation)
//        }
//        
//        vectorNode.path = mutablePath
//    }
//
//    private func applySnapping(to point: CGPoint) -> CGPoint { // Пример логики для вертикального/горизонтального прилипания
//        let snappedPoint = point
//        validateABS(point: snappedPoint) // Проверка на горизонтальное прилипание
//        return snappedPoint
//    }
//
//        //MARK: - Methods
//    func beganState(sceneLocation: CGPoint ) {
//        if let vectorNode = nodes(at: sceneLocation).compactMap({ $0 as? SKShapeNode }).first {
//            selectedVector = vectorNode
//            movingPointType = detectMovingPoint(for: vectorNode, touchLocation: sceneLocation)
//        }
//    }
//
//    func changedState(newLocation: CGPoint ) {
//        guard let vectorNode = selectedVector, let movingPointType = movingPointType else { return }
//        updateVector(vectorNode: vectorNode, pointType: movingPointType , newLocation: newLocation)
//    }
//
//    //Валидация АБС
//    func validateABS(point: CGPoint) {
//        var point = point
//
//        let horizontalA = round(point.y / snapPointThresgold)
//        let horizontalB = (point.y - horizontalA * snapPointThresgold)
//
//        let verticalA = round(point.x / snapPointThresgold)
//        let verticalB = (point.x - verticalA * snapPointThresgold)
//
//        if abs(horizontalB) < snapPointThresgold {
//            point.y = horizontalA * snapPointThresgold
//        }
//
//        if abs(verticalB) < snapPointThresgold {
//            point.x = verticalA * snapPointThresgold
//        }
//    }
//}
//
//extension CanvasScene: UIGestureRecognizerDelegate {
//    func gestureRecognizer(
//        _ gestureRecognizer: UIGestureRecognizer,
//        shouldReceive touch: UITouch) -> Bool {
//        print("Gesture should receive touch")
//        return true
//    }
//
//    func gestureRecognizer(
//        _ gestureRecognizer: UIGestureRecognizer,
//        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//}
