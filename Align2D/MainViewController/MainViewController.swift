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

    override func viewDidAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            interactor?.fetchVectors(request: MainModel.ShowVectors.Request())
        }

    private func setupUI() {
        view.backgroundColor = .white
        setupNavigationController()
        setupSKView()
        setupToolBar()
    }
    
    @objc private func addButtonAction() {
        router?.routeToAddVector()
    }
    
    @objc private func routeToSideMenu() {
        interactor?.fetchVectors(request: MainModel.ShowVectors.Request())
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

        print("SKView setup complete - userInteraction: \(skView.isUserInteractionEnabled)")
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
        customButton.tintColor = .systemBlue
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
        print("Displaying vectors: \(viewModel.vectors.count)")
        DispatchQueue.main.async {
            self.canvasScene.clearCanvas()
            viewModel.vectors.forEach { vector in
                print("Рисуем вектор: (\(vector.startX), \(vector.startY)) -> (\(vector.endX), \(vector.endY))")
                self.canvasScene.addVector(vector: vector)
            }
        }
    }
}

