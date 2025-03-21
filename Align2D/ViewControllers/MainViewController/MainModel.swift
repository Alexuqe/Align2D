    //
    //  MainModel.swift
    //  Align2D
    //
    //  Created by Sasha on 17.03.25.
    //

import UIKit

typealias MainViewModels = MainModel.ShowVectors.ViewModel.DisplayedVector

enum MainModel {
    
    enum ShowVectors {
        struct Request {}
        struct Response {
            let vectors: [VectorEntity]
        }
        
        struct ViewModel {
            struct DisplayedVector {
                let id: UUID
                let startX: CGFloat
                let startY: CGFloat
                let endX: CGFloat
                let endY: CGFloat
                let color: String
            }
            let vectors: [DisplayedVector]
        }
    }
    
    enum addVector {
        struct Request {
            let startX: CGFloat
            let startY: CGFloat
            let endX: CGFloat
            let endY: CGFloat
            let color: String
        }
        
        struct Response {
            let succes: Bool
        }
        
        struct ViewModel {
            let successMessage: String?
            let errorMessage: String?
        }
    }
    
    enum deleteVector {
        struct Request {
            let vector: VectorEntity
        }
    }
}
