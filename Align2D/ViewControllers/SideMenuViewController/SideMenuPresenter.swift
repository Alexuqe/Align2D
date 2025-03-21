//
//  SideMenuPresenter.swift
//  Align2D
//
//  Created by Sasha on 21.03.25.
//

import Foundation

protocol SideMenuPresentationLogic {
    func presentVectors(response: SideMenuModel.ShowVectors.Response)
    func presentVectorDelete(response: SideMenuDeleteResponse)
    func presentHighlightVector(response: SideMenuModel.HiglightVector.Responce)
}


final class SideMenuPresenter: SideMenuPresentationLogic {

    

    weak var viewController: SideMenuDisplayLogic?
    weak var mainViewController: MainDisplayLogic?

    func presentVectors(response: SideMenuModel.ShowVectors.Response) {
        let displayedVectors = response.vectors.map {
            SideMenuModel.ShowVectors.ViewModel.DisplayedVector(
                id: $0.id ?? UUID(),
                coordinates: "x: \($0.endX), y: \($0.endY)"
            )
        }

        let viewModel = SideMenuModel.ShowVectors.ViewModel(displayedVectors: displayedVectors)
        viewController?.displayVectors(viewModel: viewModel)
    }


    func presentVectorDelete(response: SideMenuDeleteResponse) {
        if response.success {
            mainViewController?.removeVector(id: response.vector.id ?? UUID())
        } else {
            viewController?.displayError(message: "Error delete")
        }
    }

    func presentHighlightVector(response: SideMenuModel.HiglightVector.Responce) {
        mainViewController?.higlightVector(id: response.vector.id ?? UUID())
    }


}
