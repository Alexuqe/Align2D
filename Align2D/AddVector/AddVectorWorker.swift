//
//  AddVectorWorker.swift
//  Align2D
//
//  Created by Sasha on 18.03.25.
//

final class AddVectorWorker {
    func validateVector(startX: Double, startY: Double, endX: Double, endY: Double) -> Bool {
        return !(startX == endX && startY == endY)
    }
}
