import UIKit
import SpriteKit

protocol MainDisplayLogic: AnyObject {
    func displayVectors(viewModel: MainModel.ShowVectors.ViewModel)
    func higlightVector(id: UUID)
    func resetHiglight()
    func removeVector(vector: VectorEntity)
}

final class MainViewController: UIViewController {

    var interactor: MainBusinessLogic?
    var router: MainRoutingLogic?

    private var canvasScene = CanvasScene()
    private var skView = SKView()
    private var toolbar = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        MainViewConfigurator.shared.configure(with: self)
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchVectors(request: MainModel.ShowVectors.Request())
    }

    private func setupUI() {
        view.backgroundColor = .white
        setupNavigationController()
        setupSKView()
        setupToolBar()
        setupBarButton()
    }

    @objc private func addButtonAction() {
        router?.routeToAddVector()
    }

    @objc private func routeToSideMenu() {
        router?.routeToSideMenu()
        setupBarButton()
    }

}

    //MARK: - Setup UI
private extension MainViewController {

    func setupSKView() {
        skView.frame = view.bounds
        skView.isUserInteractionEnabled = true
        skView.allowsTransparency = true
        skView.isMultipleTouchEnabled = true

        view.addSubview(skView)

        canvasScene = CanvasScene(size: view.bounds.size)
        canvasScene.isUserInteractionEnabled = true
        canvasScene.scaleMode = .aspectFit
        skView.presentScene(canvasScene)
    }
}

    //MARK: Setup NavigationController
private extension MainViewController {

    func setupNavigationController() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear

        let navigationBar = navigationController?.navigationBar
        navigationBar?.prefersLargeTitles = false
        title = "Align 2D"

        navigationBar?.scrollEdgeAppearance = appearance
        navigationBar?.standardAppearance = appearance
        navigationBar?.compactAppearance = appearance
    }

    func setupToolBar() {
        let customButton = createCustomButton()
        let actionButton = UIBarButtonItem(customView: customButton)
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)

        let appearance = UIToolbarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear

        toolbar = UIToolbar()
        toolbar.standardAppearance = appearance
        toolbar.scrollEdgeAppearance = appearance
        toolbar.setItems([flexibleSpace, actionButton], animated: false)
        toolbar.backgroundColor = .clear

            // Убираем тень и делаем фон полностью прозрачным
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)

        view.addSubview(toolbar)
        setupToolBarConstraints()
    }

    func setupBarButton() {
        let barButton = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet.below.rectangle"),
            style: .plain,
            target: self,
            action: #selector(routeToSideMenu)
        )

        guard let mainRouter = router as? MainRouter else { return }
        let currentImage = mainRouter.isActive ? "xmark.app" : "list.bullet.rectangle.fill"
        barButton.image = UIImage(systemName: currentImage)
        barButton.tintColor = .darkText

        navigationItem.leftBarButtonItem = barButton
    }

    func createCustomButton() -> UIButton {
        let customButton = UIButton(type: .system)
        customButton.tintColor = .darkText
        customButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        customButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)

        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .large)
        customButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)

        return customButton
    }

    func setupToolBarConstraints() {
        toolbar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
    }
}

    //MARK: - MainDisplayLogic Methods
extension MainViewController: MainDisplayLogic {

    func displayVectors(viewModel: MainModel.ShowVectors.ViewModel) {
        DispatchQueue.main.async {
            self.canvasScene.clearCanvas()
            viewModel.vectors.forEach {
                self.canvasScene.addVector(vector: $0)
            }
        }
    }

    func higlightVector(id: UUID) {
        canvasScene.highLightVector(by: id)
    }

    func resetHiglight() {
        canvasScene.resetHighlight()
    }

    func removeVector(vector: VectorEntity) {
        interactor?.deleteVector(request: MainModel.deleteVector.Request(vector: vector))
        canvasScene.removeVector(by: vector.id ?? UUID())
    }


}

