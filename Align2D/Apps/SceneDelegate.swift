//
//  SceneDelegate.swift
//  Align2D
//
//  Created by Sasha on 17.03.25.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let storageManager = StorageManager.shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController(rootViewController: MainViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        storageManager.saveContext()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        storageManager.saveContext()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        storageManager.saveContext()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        storageManager.saveContext()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        storageManager.saveContext()
    }


}

