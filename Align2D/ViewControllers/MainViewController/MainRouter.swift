    //
    //  MainRouter.swift
    //  Align2D
    //
    //  Created by Sasha on 17.03.25.
    //

import UIKit

protocol MainRoutingLogic: AnyObject {
    func routeToAddVector()
    func handleAddedVector(vector: AddVectorModel.AddNewVector.Request)
    func routeToSideMenu()
    func closeSideMenu(controller: SideMenuViewController)
}

final class MainRouter: NSObject, MainRoutingLogic {

    weak var viewController: MainViewController?
    weak var sideMenuVC: SideMenuViewController?
    weak var sideMenuConfigurator = SideMenuConfigurator.shared
    private var addVectorConfig = AddVectorConfigurator.shared
    

    func routeToAddVector() {
        let addVectorVC = AddVectorViewController()
        addVectorConfig.configure(with: addVectorVC)
        addVectorVC.modalPresentationStyle = .fullScreen

        guard let addVectorRouter = addVectorVC.router as? AddVectorRouter else { return }
        addVectorRouter.mainRouter = self

        viewController?.present(addVectorVC, animated: true)
    }

    func handleAddedVector(vector: AddVectorModel.AddNewVector.Request) {
        let request = MainModel.addVector.Request(
            startX: vector.startX,
            startY: vector.startY,
            endX: vector.endX,
            endY: vector.endY,
            color: vector.color
        )
        viewController?.interactor?.saveVector(request: request)
    }

    func routeToSideMenu() {
        guard sideMenuVC == nil else {
            print("SideMenu is already open")
            return
        }

        guard let viewControllerWidth = viewController?.view.bounds.width else {
            print("Cannot get view controller width")
            return
        }

        let sideMenuWidth = viewControllerWidth * 0.33 // Fixed calculation
        print("Creating SideMenu with width: \(sideMenuWidth)")

        let sideMenuVC = SideMenuViewController()
        sideMenuConfigurator?.configure(with: sideMenuVC)
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

        print("Starting SideMenu animation from x: \(sideMenuVC.view.frame.origin.x)")
        UIView.animate(withDuration: 0.3) {
            sideMenuVC.view.frame.origin.x = 0
        } completion: { finished in
            print("SideMenu animation completed: \(finished)")
        }
    }
    
    func closeSideMenu(controller: SideMenuViewController) {
        guard let sideMenuVC = sideMenuVC else {
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
            self.sideMenuVC = nil
        })
    }



}
