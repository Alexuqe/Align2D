//
//  AddVectorConfigurator.swift
//  Align2D
//
//  Created by Sasha on 19.03.25.
//

final class AddVectorConfigurator {
    static let shared = AddVectorConfigurator()

    private init() {}

    func configure(with viewController: AddVectorViewController) {
        let interactor = AddVectorInteractor()
        let presenter = AddVectorPresenter()
        let router = AddVectorRouter()
        let worker = AddVectorWorker()

        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        viewController.interactor = interactor
        viewController.router = router
    }
}
