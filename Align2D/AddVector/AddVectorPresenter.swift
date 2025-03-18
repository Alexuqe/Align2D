//
//  AddVectorPresenter.swift
//  Align2D
//
//  Created by Sasha on 18.03.25.
//

import UIKit

protocol AddVectorPresentationLogic {
    func presentAddVectorResult(responce: AddVectorModel.AddNewVector.Responce)
}


final class AddVectorPresenter: AddVectorPresentationLogic {

    weak var viewController: AddVectorDisplayLogic?

    func presentAddVectorResult(responce: AddVectorModel.AddNewVector.Responce) {
        if responce.succes {
            let viewModel = AddVectorModel.AddNewVector.ViewModel(
                succesMessage: Message.succes.title,
                errorMesage: nil)
            viewController?.displayAddVectorResult(viewModel: viewModel)

        } else {
            let viewModel = AddVectorModel.AddNewVector.ViewModel(
                succesMessage: nil,
                errorMesage: Message.error.title)
            viewController?.displayAddVectorResult(viewModel: viewModel)
        }
    }
}

enum Message {
    case succes
    case error

    var title: String {
        switch self {
            case .succes:
                "Вектор успешно добавлен"
            case .error:
                "Ошибка при добавлении"
        }
    }
}
