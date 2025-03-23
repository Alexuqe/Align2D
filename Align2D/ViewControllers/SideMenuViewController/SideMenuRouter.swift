//
//  SideMenuRouter.swift
//  Align2D
//
//  Created by Sasha on 21.03.25.
//

import Foundation
import UIKit


protocol SideMenuRoutingLogic: AnyObject {
    func closeSideMenu(controller: SideMenuViewController)
}

final class SideMenuRouter: SideMenuRoutingLogic {

    weak var viewController: SideMenuViewController?

    func closeSideMenu(controller: SideMenuViewController) {
        guard let sideMenuVC = viewController.self else {
            print("No SideMenu to close")
            return
        }

        print("Starting close animation")
        UIView.animate(withDuration: 0.3, animations: {
            sideMenuVC.view.frame.origin.x = -(sideMenuVC.view.bounds.width)
        }, completion: { finished in
            print("Close animation completed: \(finished)")
            sideMenuVC.view.removeFromSuperview()
            sideMenuVC.willMove(toParent: nil)
            sideMenuVC.removeFromParent()
            sideMenuVC.didMove(toParent: nil)
        })
    }


}
