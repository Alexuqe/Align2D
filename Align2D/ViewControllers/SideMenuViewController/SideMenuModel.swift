//
//  SideMenuModel.swift
//  Align2D
//
//  Created by Sasha on 21.03.25.
//

import Foundation

typealias SideMenuDeleteResponse = SideMenuModel.DeleteVector.Response
typealias SideMenuShowVectorsRequest = SideMenuModel.ShowVectors.Request

enum SideMenuModel {
    enum ShowVectors {
        struct Request {}

        struct Response {
            let vectors: [VectorEntity]
        }

        struct ViewModel {
            struct DisplayedVector {
                let id: UUID
                let coordinates: String
            }
            let displayedVectors: [DisplayedVector]
        }
    }

    enum DeleteVector {
        struct Request {
            let vector: VectorEntity
        }

        struct Response {
            let vector: VectorEntity
            let success: Bool
        }

        struct ViewModel {
            let succesMessage: String
            let errorMessage: String?
        }
    }

    enum HiglightVector {
        struct Request {
            let vector: VectorEntity
        }

        struct Responce {
            let vector: VectorEntity
        }
    }
}
