    //
    //  AddVectorInteractor.swift
    //  Align2D
    //
    //  Created by Sasha on 18.03.25.
    //

import UIKit

protocol AddVectorBusinessLogic {
    func addVector(request: AddVectorModel.AddNewVector.Request)
}

final class AddVectorInteractor: AddVectorBusinessLogic {
    
    var presenter: AddVectorPresentationLogic?
    var worker: AddVectorWorker?
    
    func addVector(request: AddVectorModel.AddNewVector.Request) {
        guard let worker = worker else { return }
        
        let validate = worker.validateVector(
            startX: request.startX,
            startY: request.startY,
            endX: request.endX,
            endY: request.endY
        )
        
        if validate {
            worker.saveVector(request: request) { [weak self] result in
                guard let self else { return }
                switch result {
                    case .success():
                        let responce = AddVectorModel.AddNewVector.Response(succes: true)
                        self.presenter?.presentAddVectorResult(response: responce)
                    case .failure:
                        let responce = AddVectorModel.AddNewVector.Response(succes: false)
                        self.presenter?.presentAddVectorResult(response: responce)
                }
            }
        } else {
            let responce = AddVectorModel.AddNewVector.Response(succes: false)
            presenter?.presentAddVectorResult(response: responce)
        }
    }
}
