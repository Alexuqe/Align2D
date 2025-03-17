    //
    //  MainPresenter.swift
    //  Align2D
    //
    //  Created by Sasha on 17.03.25.
    //

import UIKit

protocol MainPresentationLogic {
    func presentVectors(responce: MainModel.ShowVectors.Response)
    func presentError(message: String)
    func updateGesture(offset: CGPoint)
}

final class MainPresenter: MainPresentationLogic {

    weak var viewController: MainDisplayLogic?

    func presentVectors(responce: MainModel.ShowVectors.Response) {
        let displayVectors = responce.vectors.map {
            MainViewModels(
                id: $0.id,
                start: $0.startPoint,
                end: $0.endPoint,
                color: $0.color)
        }
        let viewModel = MainModel.ShowVectors.ViewModel(vectors: displayVectors)
        viewController?.displayVectors(viewModel: viewModel)
    }

    func presentError(message: String) {
        viewController?.displayError(message: message)
    }

    func updateGesture(offset: CGPoint) {
        viewController?.updateCanvasOffset(offset: offset)
    }


}
