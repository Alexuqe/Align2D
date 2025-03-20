    //
    //  AddVectorRouter.swift
    //  Align2D
    //
    //  Created by Sasha on 18.03.25.
    //

import UIKit

protocol AddVectorRoutingLogic {
    func closeAddVectorScreen()
    func passVectorToMain(vector: AddVectorModel.AddNewVector.Request)
}


final class AddVectorRouter: AddVectorRoutingLogic {
    
    weak var viewController: AddVectorViewController?
    weak var mainRouter: MainRoutingLogic?

    func closeAddVectorScreen() {
        self.viewController?.dismiss(animated: true)
    }
    
    func passVectorToMain(vector: AddVectorModel.AddNewVector.Request) {
        mainRouter?.handleAddedVector(vector: vector)
        closeAddVectorScreen()
    }
}
