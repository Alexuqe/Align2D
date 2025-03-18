//
//  AddVectorViewController.swift
//  Align2D
//
//  Created by Sasha on 18.03.25.
//

import UIKit

protocol AddVectorDisplayLogic: AnyObject {
    func displayAddVectorResult(viewModel: AddVectorModel.AddNewVector.ViewModel)
}

final class AddVectorViewController: UIViewController {

    var interactor: AddVectorBusinessLogic?
    var router: AddVectorRoutingLogic?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
    }

}

extension AddVectorViewController: AddVectorDisplayLogic {

    func displayAddVectorResult(viewModel: AddVectorModel.AddNewVector.ViewModel) {
        if let succesMessage = viewModel.succesMessage {
            print(succesMessage)
            router?.closeAddVectorScreen()
        } else if let errorMesage = viewModel.errorMesage {
            print(errorMesage)
        }
    }
    

}
