//
//  SideMenuConfigurator.swift
//  Align2D
//
//  Created by Sasha on 21.03.25.
//

import Foundation

final class SideMenuConfigurator {

    static let shared = SideMenuConfigurator()

    private init() {}

    func configure(with viewController: SideMenuViewController, mainVC: MainDisplayLogic?) {
        print("SideMenuConfigurator: Starting configuration...")
        
        let interactor = SideMenuInteractor()
        let presenter = SideMenuPresenter()
        let router = SideMenuRouter()
        let worker = SideMenuWorker()

        viewController.router = router
        viewController.interactor = interactor

        interactor.presenter = presenter
        interactor.worker = worker

        presenter.viewController = viewController
        presenter.mainViewController = mainVC
        router.viewController = viewController

        print("SideMenu configured. MainViewController set: \(mainVC != nil)")
    }

}
