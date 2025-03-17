    //
    //  ViewController.swift
    //  Align2D
    //
    //  Created by Sasha on 17.03.25.
    //

import UIKit
import SpriteKit

protocol MainDisplayLogic: AnyObject {
    func displayVectors(viewModel: MainModel.ShowVectors.ViewModel)
    func displayError(message: String)
    func updateCanvasOffset(offset: CGPoint)
}

final class MainViewController: UIViewController {

    var interactor: MainBusinessLogic?
    private var skView = SKView()
    private var toolbar = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        MainViewConfigurator.shared.configure(with: self)
        view.backgroundColor = .white
        setupNavigationController()
        setupSKView()
        setupToolBar()
    }

    @objc private func addButtonAction() {

    }

}

    //MARK: - Setup UI
private extension MainViewController {

    func setupSKView() {
        skView.frame = view.bounds
        view.addSubview(skView)

        let scene = CanvasScene(size: view.bounds.size)
        skView.presentScene(scene)
    }
}

    //MARK: Setup NavigationController
private extension MainViewController {

    func setupNavigationController() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        let navigationBar = navigationController?.navigationBar
        navigationBar?.tintColor = .systemBlue
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
        toolbar.standardAppearance = appearance
        toolbar.scrollEdgeAppearance = appearance

        toolbar.tintColor = .white
        toolbar.setItems([flexibleSpace, actionButton], animated: false)
        toolbar.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(toolbar)
        setupToolBarConstraints()
    }

    func createCustomButton() -> UIButton {
        let customButton = UIButton(type: .system)
        customButton.tintColor = .white
        customButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        customButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)

        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .large)
        customButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)

        return customButton
    }

    func setupToolBarConstraints() {
        NSLayoutConstraint.activate([
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }
}

    //MARK: - MainDisplayLogic Methods
extension MainViewController: MainDisplayLogic {

    func displayVectors(viewModel: MainModel.ShowVectors.ViewModel) {
        guard let scene = skView.scene as? CanvasScene else { return }
        scene.clearCanvas()

        for vector in viewModel.vectors {
            scene.addVector(
                id: vector.id,
                start: vector.start,
                end: vector.end,
                color: vector.color)
        }
    }

    func displayError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }

    func updateCanvasOffset(offset: CGPoint) {
        guard let scene = skView.scene as? CanvasScene else { return }
        scene.updateOffset(offset: offset)
    }
}

