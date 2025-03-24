import UIKit

protocol AddVectorRoutingLogic {
    func closeAddVectorScreen()
}

final class AddVectorRouter: AddVectorRoutingLogic {
    
    weak var viewController: AddVectorViewController?
    weak var mainRouter: MainRoutingLogic?
    
    func closeAddVectorScreen() {
        self.viewController?.dismiss(animated: true)
    }
}
