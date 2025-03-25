import UIKit

protocol MainRoutingLogic: AnyObject {
    func routeToAddVector()
    func routeToSideMenu()
    func closeSideMenu()
}

final class MainRouter: NSObject, MainRoutingLogic {

    weak var viewController: MainViewController?
    weak var sideMenuVC: SideMenuViewController?
    weak var sideMenuConfigurator = SideMenuConfigurator.shared
    var isActive = false
    private var addVectorConfig = AddVectorConfigurator.shared

    func routeToAddVector() {
        let addVectorVC = AddVectorViewController()
        addVectorConfig.configure(with: addVectorVC)
        addVectorVC.modalPresentationStyle = .overFullScreen

        viewController?.present(addVectorVC, animated: true)
    }

    func routeToSideMenu() {
        isActive.toggle()
        
        switch isActive {
            case true:
                openSideMenu()
            case false:
                closeSideMenu()
        }
    }

    func openSideMenu() {
        guard sideMenuVC == nil else { return }
        guard let viewControllerWidth = viewController?.view.bounds.width else { return }
        guard let mainVC = viewController else { return }

        let sideMenuWidth = viewControllerWidth * 0.33 

        let sideMenuVC = SideMenuViewController()
        sideMenuConfigurator?.configure(with: sideMenuVC, mainVC: mainVC)
        self.sideMenuVC = sideMenuVC

        sideMenuVC.view.frame = CGRect(
            x: -sideMenuWidth,
            y: 0,
            width: sideMenuWidth,
            height: viewController?.view.bounds.height ?? 0
        )

        viewController?.addChild(sideMenuVC)
        viewController?.view.addSubview(sideMenuVC.view)
        sideMenuVC.didMove(toParent: viewController)

        UIView.animate(withDuration: 0.3) {
            sideMenuVC.view.frame.origin.x = 0
        }
    }

    func closeSideMenu() {
        guard let sideMenuVC = sideMenuVC else {
            return
        }

        UIView.animate(withDuration: 0.3, animations: {
            sideMenuVC.view.frame.origin.x = -(sideMenuVC.view.bounds.width)
        }, completion: { finished in
            sideMenuVC.view.removeFromSuperview()
            sideMenuVC.willMove(toParent: nil)
            sideMenuVC.removeFromParent()
            self.sideMenuVC = nil
        })
    }
}
