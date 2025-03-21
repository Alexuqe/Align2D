//
//  MainConfigurator.swift
//  Align2D
//
//  Created by Sasha on 17.03.25.
//

import Foundation

final class MainViewConfigurator {

    static let shared = MainViewConfigurator()

    private init() {}

    func configure(with viewController: MainViewController) {
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()
        let worker = MainWorker()

        viewController.router = router
        viewController.interactor = interactor

        interactor.presenter = presenter
        interactor.worker = worker

        presenter.viewController = viewController
        router.viewController = viewController
    }

}
