import UIKit

protocol MainPresentationLogic {
    func presentVectors(response: MainModel.ShowVectors.Response)
}

final class MainPresenter: MainPresentationLogic {

    weak var viewController: MainDisplayLogic?

    func presentVectors(response: MainModel.ShowVectors.Response) {

        let displayVectors: [MainModelProtocol] = response.vectors.map {
            MainViewModels(vectors: $0)
        }

        let viewModel = MainModel.ShowVectors.ViewModel(vectors: displayVectors)
        viewController?.displayVectors(viewModel: viewModel)
    }
}
