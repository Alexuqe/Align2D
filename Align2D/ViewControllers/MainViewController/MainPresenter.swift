import UIKit

protocol MainPresentationLogic {
    func presentVectors(response: MainModel.ShowVectors.Response)
}

final class MainPresenter: MainPresentationLogic {

    weak var viewController: MainDisplayLogic?

    func presentVectors(response: MainModel.ShowVectors.Response) {
        let viewModel = MainModel.ShowVectors.ViewModel(
            vectors: response.vectors.map {
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
