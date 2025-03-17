    //
    //  MainModel.swift
    //  Align2D
    //
    //  Created by Sasha on 17.03.25.
    //

import UIKit

typealias MainViewModels = MainModel.ShowVectors.ViewModel.DisplayedVector

protocol MainViewModelProtocol {
    var id: UUID { get set }
    var start: CGPoint { get set }
    var end: CGPoint { get set }
    var color: UIColor { get set }
}

enum MainModel {
    
    enum ShowVectors {
        struct Request {}
        struct Response {
            let vectors: [VectorDataModel]
        }

        struct ViewModel {
            struct DisplayedVector {
                var id: UUID
                var start: CGPoint
                var end: CGPoint
                var color: UIColor
            }
            let vectors: [DisplayedVector]
        }
    }

    enum addVector {
        struct Request {
            let start: CGPoint
            let end: CGPoint
            let color: UIColor
        }
    }

    enum deleteVector {
        struct Request {
            let vectorID: UUID
        }
    }

    enum Gesture {
        struct Request {
            let translation: CGPoint
        }
    }
}
