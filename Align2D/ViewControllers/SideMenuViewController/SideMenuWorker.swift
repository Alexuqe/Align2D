//
//  SideMenuWorker.swift
//  Align2D
//
//  Created by Sasha on 21.03.25.
//

import Foundation


final class SideMenuWorker {

    let storageManager = StorageManager.shared

    func fetchVectors(completion: @escaping (Result<[VectorEntity], Error>) -> Void) {
        storageManager.fetch(completion: completion)
    }

    func deleteVector(vector: VectorEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        storageManager.delete(vector: vector, completion: completion)
    }
}
