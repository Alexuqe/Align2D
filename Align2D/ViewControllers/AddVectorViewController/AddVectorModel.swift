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
            let succesMessage: String?
            let errorMesage: String?
        }
    }
}
