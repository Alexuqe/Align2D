import UIKit

protocol AddVectorRoutingLogic {
    func closeAddVectorScreen()
}

final class AddVectorRouter: AddVectorRoutingLogic {
    
    weak var viewController: AddVectorViewController?
    weak var mainRouter: MainRoutingLogic?
    var mainInteractor: MainBusinessLogic?

    func closeAddVectorScreen() {
        self.viewController?.dismiss(animated: true) { [weak self] in
            self?.mainInteractor?.fetchVectors(request: MainModel.ShowVectors.Request())
        }
    }
}
