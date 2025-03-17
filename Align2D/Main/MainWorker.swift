//
//  MainWorker.swift
//  Align2D
//
//  Created by Sasha on 17.03.25.
//

import UIKit

final class MainWorker {
    private let storageManager = StorageManager.shared

    func fetchVector(completion: @escaping (Result<[VectorDataModel], Error>) -> Void) {
        storageManager.fetchVectors(completion: completion)
    }

    func saveVector(model: VectorDataModel, completion: @escaping (Result<Void, Error>) -> Void) {
        storageManager.saveVector(model: model, completion: completion)
    }

    func deleteVector(by id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        storageManager.deleteVector(by: id, completion: completion)
    }
}
