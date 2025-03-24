import Foundation

protocol SideMenuPresentationLogic {
    func presentVectors(response: SideMenuModel.ShowVectors.Response)
    func presentVectorDelete(response: SideMenuDeleteResponse)
    func presentHighlightVector(response: SideMenuModel.HiglightVector.Responce)
    func presentResetHighlight()
}

final class SideMenuPresenter: SideMenuPresentationLogic {
    
    weak var viewController: SideMenuDisplayLogic?
    weak var mainViewController: MainDisplayLogic?
    var mainInteractor: MainBusinessLogic?
    
    func presentVectors(response: SideMenuModel.ShowVectors.Response) {
        let displayVectors: [SideMenuCellModelProtocol] = response.vectors.map {
            SideViewModel(vectors: $0)
        }
        
        let viewModel = SideMenuModel.ShowVectors.ViewModel(displayedVectors: displayVectors)
        viewController?.displayVectors(viewModel: viewModel)
    }
    
    func presentVectorDelete(response: SideMenuDeleteResponse) {
        if response.success {
            mainViewController?.removeVector(vector: response.vector)
        } else {
            viewController?.displayError(message: "Error delete")
        }
    }
    
    func presentHighlightVector(response: SideMenuModel.HiglightVector.Responce) {
        mainViewController?.higlightVector(id: response.vector.id ?? UUID())
    }
    
    func presentResetHighlight() {
        mainViewController?.resetHiglight()
    }
    
    
}
