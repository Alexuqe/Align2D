//
//  SideMenuRouter.swift
//  Align2D
//
//  Created by Sasha on 21.03.25.
//

import Foundation


protocol SideMenuRoutingLogic: AnyObject {
    func highlightVector(id: UUID)
}

final class SideMenuRouter: SideMenuRoutingLogic {

    weak var viewController: SideMenuViewController?

    func highlightVector(id: UUID) {
//        NotificationCenter.default.post(name: .highlightVector, object: id)
    }
    

}
