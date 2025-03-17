//
//  AppDelegate.swift
//  Align2D
//
//  Created by Sasha on 17.03.25.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let storageManager = StorageManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle
    func applicationWillTerminate(_ application: UIApplication) {
        storageManager.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        storageManager.saveContext()
    }
}

