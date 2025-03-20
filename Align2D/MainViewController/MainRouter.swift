//
//  MainRouter.swift
//  Align2D
//
//  Created by Sasha on 17.03.25.
//

import UIKit

protocol MainRoutingLogic: AnyObject {
    func routeToAddVector()
    func handleAddedVector(vector: AddVectorModel.AddNewVector.Request)
    func routeToSideMenu(vectors: [VectorEntity])
}

final class MainRouter: NSObject, MainRoutingLogic {

    weak var viewController: MainViewController?
    private var addVectorConfig = AddVectorConfigurator.shared

    func routeToAddVector() {
        let addVectorVC = AddVectorViewController()
        addVectorConfig.configure(with: addVectorVC)
        addVectorVC.modalPresentationStyle = .fullScreen

        guard let addVectorRouter = addVectorVC.router as? AddVectorRouter else { return }
        addVectorRouter.mainRouter = self

        viewController?.present(addVectorVC, animated: true)
    }

    func handleAddedVector(vector: AddVectorModel.AddNewVector.Request) {
        let request = MainModel.addVector.Request(
            startX: vector.startX,
            startY: vector.startY,
            endX: vector.endX,
            endY: vector.endY,
            color: vector.color
        )
        viewController?.interactor?.saveVector(request: request)
    }

    func routeToSideMenu(vectors: [VectorEntity]) {
        let sideMenu = SideMenuViewController()
        viewController?.present(sideMenu, animated: true)
    }


}
