//
//  AddVectorRouter.swift
//  Align2D
//
//  Created by Sasha on 18.03.25.
//

import UIKit

protocol AddVectorRoutingLogic {
    func closeAddVectorScreen()
}


final class AddVectorRouter: AddVectorRoutingLogic {

    weak var viewController: AddVectorViewController?

    func closeAddVectorScreen() {
        viewController?.dismiss(animated: true)
    }
}
