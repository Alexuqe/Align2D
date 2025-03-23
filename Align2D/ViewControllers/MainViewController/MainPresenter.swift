    //
    //  MainPresenter.swift
    //  Align2D
    //
    //  Created by Sasha on 17.03.25.
    //

import UIKit

protocol MainPresentationLogic {
    func presentVectors(response: MainModel.ShowVectors.Response)
}

final class MainPresenter: MainPresentationLogic {

    weak var viewController: MainDisplayLogic?

    func presentVectors(response: MainModel.ShowVectors.Response) {
        print("Получено векторов: \(response.vectors.count)")
        let viewModel = MainModel.ShowVectors.ViewModel(
            vectors: response.vectors.map {
                print("Processing vector with ID: \($0.id?.uuidString ?? "nil")")
                return MainViewModels(
                    id: $0.id ?? UUID(),
                    startX: CGFloat($0.startX),
                    startY: CGFloat($0.startY),
                    endX: CGFloat($0.endX),
                    endY: CGFloat($0.endY),
                    color: $0.color ?? ""
                )
            })
        viewController?.displayVectors(viewModel: viewModel)
    }
}
