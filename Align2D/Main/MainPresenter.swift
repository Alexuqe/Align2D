    //
    //  MainPresenter.swift
    //  Align2D
    //
    //  Created by Sasha on 17.03.25.
    //

import UIKit

protocol MainPresentationLogic {
    func presentVectors(responce: MainModel.ShowVectors.Response)
}

final class MainPresenter: MainPresentationLogic {

    weak var viewController: MainDisplayLogic?

    func presentVectors(responce: MainModel.ShowVectors.Response) {
        let viewModel = MainModel.ShowVectors.ViewModel(
            vectors: responce.vectors.map
                { vector in
                    return MainModel.ShowVectors.ViewModel.DisplayedVector(
                        id: vector.id ?? UUID(),
                        startX: vector.startX,
                        startY: vector.startY,
                        endX: vector.endX,
                        endY: vector.endY,
                        color: UIColor(hexString: vector.color ?? "")
                    )
                })
        viewController?.displayVectors(viewModel: viewModel)
    }
}
