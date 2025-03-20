//
//  Extension + Collection.swift
//  Align2D
//
//  Created by Sasha on 20.03.25.
//

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
