    //
    //  AddVectorPresenter.swift
    //  Align2D
    //
    //  Created by Sasha on 18.03.25.
    //

import UIKit

protocol AddVectorPresentationLogic {
    func presentAddVectorResult(response: AddVectorModel.AddNewVector.Response)
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

final class AddVectorPresenter: AddVectorPresentationLogic {

    weak var viewController: AddVectorDisplayLogic?

    func presentAddVectorResult(response: AddVectorModel.AddNewVector.Response) {
        if response.succes {
            let viewModel = AddVectorModel.AddNewVector.ViewModel(
                succesMessage: "Вектор успешно добавлен",
                errorMesage: nil
            )
            viewController?.displayAddVectorResult(viewModel: viewModel)
        } else {
            let viewModel = AddVectorModel.AddNewVector.ViewModel(
                succesMessage: nil,
                errorMesage: "Ошибка: некорректные данные"
            )
            viewController?.displayAddVectorResult(viewModel: viewModel)
        }
    }
}

