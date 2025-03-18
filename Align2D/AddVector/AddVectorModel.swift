    //
    //  AddVectorModel.swift
    //  Align2D
    //
    //  Created by Sasha on 18.03.25.
    //

import UIKit

enum AddVectorModel {
    
    enum AddNewVector {
        struct Request {
            let startX: Double
            let startY: Double
            let endX: Double
            let endY: Double
            let color: UIColor
        }

        struct Responce {
            let succes: Bool
        }

        struct ViewModel {
            let succesMessage: String?
            let errorMesage: String?
        }
    }
}
