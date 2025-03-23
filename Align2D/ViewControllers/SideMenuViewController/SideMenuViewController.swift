//
//  SideMenuViewController.swift
//  Align2D
//
//  Created by Sasha on 18.03.25.
//

import UIKit

protocol SideMenuDisplayLogic: AnyObject {
    func displayVectors(viewModel: SideMenuModel.ShowVectors.ViewModel)
    func displayError(message: String)
}

final class SideMenuViewController: UIViewController {

    //MARK: UI Elements
    private let tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView())

    //MARK: - Properties
    var interactor: SideMenuBuisnesLogic?
    var router: SideMenuRoutingLogic?
    private var vectors: [SideMenuCellModelProtocol] = []

    //MARK: - Initializer
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    deinit {
        print("Deinit")
    }


//    MARK: - Actions
    @objc private func closedSideMenu() {
        router?.closeSideMenu(controller: self)
    }
}

    //MARK: - Setup UI
private extension SideMenuViewController {

    func setupUI() {
        interactor?.fetchVectors(request: SideMenuModel.ShowVectors.Request())
        view.backgroundColor = .white
        view.addSubviews(tableView)

        setupTableView()
        setupConstraints()
    }

    private func setupTableView() {
        tableView.register(SideMenuCell.self, forCellReuseIdentifier: "VectorsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20)
        ])
    }
}

//MARK: - TableView DataSource
extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vectors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vectorsViewModel = vectors[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: vectorsViewModel.identifier, for: indexPath)
        guard let cell = cell as? SideMenuCell else { return UITableViewCell() }
        cell.viewModel = vectorsViewModel

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Vectors"
    }
}

    //MARK: - TableView Delegate
extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        vectors[indexPath.row].cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let vectors = vectors[indexPath.row]
        interactor?.higlightVector(request: SideMenuModel.HiglightVector.Request(vector: vectors.vector))
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let vectors = vectors[indexPath.row]
        interactor?.resetHighlight(request: SideMenuModel.ResetHighlight.Request(vector: vectors.vector))
    }
}

//MARK: - SideMenuDisplayLogic
extension SideMenuViewController: SideMenuDisplayLogic {

    func displayError(message: String) {
        print("Error: \(message)")
    }

    func displayVectors(viewModel: SideMenuModel.ShowVectors.ViewModel) {
        vectors = viewModel.displayedVectors
        tableView.reloadData()
    }
}
