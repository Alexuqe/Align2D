import Foundation
import UIKit

protocol SideMenuRoutingLogic: AnyObject {
    func closeSideMenu(controller: SideMenuViewController)
}

final class SideMenuRouter: SideMenuRoutingLogic {

    weak var viewController: SideMenuViewController?

    func closeSideMenu(controller: SideMenuViewController) {
        guard let sideMenuVC = viewController.self else { return }

        UIView.animate(withDuration: 0.3, animations: {
            sideMenuVC.view.frame.origin.x = -(sideMenuVC.view.bounds.width)
        }, completion: { finished in
            sideMenuVC.view.removeFromSuperview()
            sideMenuVC.willMove(toParent: nil)
            sideMenuVC.removeFromParent()
            sideMenuVC.didMove(toParent: nil)
        })
    }


}
