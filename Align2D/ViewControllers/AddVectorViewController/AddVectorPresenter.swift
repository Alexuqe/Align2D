import UIKit

protocol AddVectorPresentationLogic {
    func presentAddVectorResult(response: AddVectorModel.AddNewVector.Response)
}

final class AddVectorPresenter: AddVectorPresentationLogic {

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

