//
//  MainWorker.swift
//  Align2D
//
//  Created by Sasha on 17.03.25.
//

import UIKit

final class MainWorker {
    private let storageManager = StorageManager.shared

    func fetchVector(completion: @escaping (Result<[VectorEntity], Error>) -> Void) {
        storageManager.fetch(completion: completion)
    }

    func saveVector(model: VectorModel, completion: @escaping (Result<Void, Error>) -> Void) {
        storageManager.saveVector(vector: model, completion: completion)
    }

    func deleteVector(vector: VectorEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        storageManager.delete(vector: vector, completion: completion)
    }
}
