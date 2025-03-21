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




    var interactor: SideMenuBuisnesLogic?
    var router: SideMenuRoutingLogic?


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        SideMenuConfigurator.shared.configure(with: self)
    }
}

extension SideMenuViewController: SideMenuDisplayLogic {
    func displayError(message: String) {
        print("Error: \(message)")
    }
    

    func displayVectors(viewModel: SideMenuModel.ShowVectors.ViewModel) {

    }
    

}
