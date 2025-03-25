

final class AddVectorConfigurator {
    static let shared = AddVectorConfigurator()

    private init() {}

    func configure(with viewController: AddVectorViewController) {
        let interactor = AddVectorInteractor()
        let presenter = AddVectorPresenter()
        let router = AddVectorRouter()
        let worker = AddVectorWorker()

        if let mainVC = viewController.presentingViewController as? MainViewController {
            router.mainInteractor = mainVC.interactor
        }

        interactor.presenter = presenter
        interactor.worker = worker

        presenter.viewController = viewController
        router.viewController = viewController

        viewController.interactor = interactor
        viewController.router = router
    }
}
