    //
    //  AddVectorWorker.swift
    //  Align2D
    //
    //  Created by Sasha on 18.03.25.
    //

import UIKit

final class AddVectorWorker {

    private let storageManager = StorageManager.shared

    func validateVector(startX: Double, startY: Double, endX: Double, endY: Double) -> Bool {
        return !(startX == endX && startY == endY)
    }

    func saveVector(request: AddVectorModel.AddNewVector.Request, completion: @escaping (Result<Void, Error>) -> Void) {
        storageManager.saveVector(
            vector: VectorModel(
                id: UUID(),
                startX: request.startX,
                startY: request.startY,
                endX: request.endX,
                endY: request.endY,
                color: request.color
            ),
            completion: completion
        )
    }
}
