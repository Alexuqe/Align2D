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
    weak var sideMenu: SideMenuViewController?
    weak var sideMenuCOnfigurator: SideMenuConfigurator?
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
            // Убедимся, что viewController установлен
        guard let mainVC = viewController else { return }

        if sideMenu == nil {
                // Создаём экземпляр SideMenuViewController
            let sideMenuVC = SideMenuViewController()
            sideMenuCOnfigurator?.configure(with: sideMenuVC)

                // Устанавливаем размеры и изначальную позицию SideMenu
            let screenWidth = mainVC.view.bounds.width
            let screenHeight = mainVC.view.bounds.height
            let menuWidth = screenWidth * 0.33
            sideMenuVC.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: screenHeight)

                // Добавляем SideMenu как дочерний ViewController
            mainVC.addChild(sideMenuVC)
            mainVC.view.addSubview(sideMenuVC.view)
            sideMenuVC.didMove(toParent: mainVC)

                // Сохраняем ссылку на SideMenu
            self.sideMenu = sideMenuVC

                // Анимация выезда меню
            UIView.animate(withDuration: 0.3) {
                sideMenuVC.view.frame.origin.x = 0
            }
        }
    }

    func closeSideMenu(controller: SideMenuViewController) {

        UIView.animate(withDuration: 0.3) {
            controller.view.frame.origin.x = -controller.view.frame.width
        } completion: { _ in
            controller.willMove(toParent: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParent()
           
        }
    }



}
