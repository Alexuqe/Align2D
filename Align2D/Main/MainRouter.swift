//
//  MainRouter.swift
//  Align2D
//
//  Created by Sasha on 17.03.25.
//

import UIKit

protocol MainRoutingLogic {
    func routeToAddVector()
    func routeToSideMenu(vectors: [VectorEntity])
}

final class MainRouter: NSObject, MainRoutingLogic {

    

    weak var viewController: MainViewController?

    func routeToAddVector() {
        let addVC = AddVectorViewController()
        addVC.modalPresentationStyle = .popover
        addVC.modalTransitionStyle = .coverVertical
        viewController?.present(addVC, animated: true)
    }

    func routeToSideMenu(vectors: [VectorEntity]) {
        let sideMenu = SideMenuViewController()
        
    }


}
