//
//  SideMenuInteractro.swift
//  Align2D
//
//  Created by Sasha on 21.03.25.
//

import Foundation

protocol SideMenuBuisnesLogic: AnyObject {
    func fetchVectors(request: SideMenuModel.ShowVectors.Request)
    func deleteVectors(request: SideMenuModel.DeleteVector.Request)
    func higlightVector(request: SideMenuModel.HiglightVector.Request)
    func resetHighlight(request: SideMenuModel.ResetHighlight.Request)
}

final class SideMenuInteractor: SideMenuBuisnesLogic {

    var presenter: SideMenuPresentationLogic?
    var worker: SideMenuWorker?

    func fetchVectors(request: SideMenuModel.ShowVectors.Request) {
        worker?.fetchVectors(completion: { result in
            switch result {
                case .success(let vectors):
                    let responce = SideMenuModel.ShowVectors.Response(vectors: vectors)
                    self.presenter?.presentVectors(response: responce)
                case .failure(let error):
                    print("Ошибка получение векторов SideMenu \(error)")
            }
        })
    }

    func deleteVectors(request: SideMenuModel.DeleteVector.Request) {
        worker?.deleteVector(vector: request.vector, completion: { [weak self] result in
            guard let self else { return }
            switch result {
                case .success:
                    let response = SideMenuDeleteResponse(vector: request.vector, success: true)
                    self.presenter?.presentVectorDelete(response: response)
                    self.fetchVectors(request: SideMenuModel.ShowVectors.Request())
                case .failure:
                    let response = SideMenuDeleteResponse(vector: request.vector, success: false)
                    self.presenter?.presentVectorDelete(response: response)
            }
        })
    }

    func higlightVector(request: SideMenuModel.HiglightVector.Request) {
        let response = SideMenuModel.HiglightVector.Responce(vector: request.vector)
        presenter?.presentHighlightVector(response: response)
    }

    func resetHighlight(request: SideMenuModel.ResetHighlight.Request) {
        presenter?.presentResetHighlight()
    }
}
