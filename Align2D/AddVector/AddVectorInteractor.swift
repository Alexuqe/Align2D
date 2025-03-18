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
        if worker?.validateVector(
            startX: request.startX,
            startY: request.startY,
            endX: request.endX,
            endY: request.endY) == true {
            let responce = AddVectorModel.AddNewVector.Responce(succes: true)
            presenter?.presentAddVectorResult(responce: responce)

        } else {
            let responce = AddVectorModel.AddNewVector.Responce(succes: false)
            presenter?.presentAddVectorResult(responce: responce)
        }
    }

}
