//
//  SceneDelegate.swift
//  OnTheMap
//
//  Created by Sandra Q on 5/18/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

import FacebookLogin
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var coordinator: MainCoordinator!
    var window: UIWindow?
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        let appWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
        appWindow.windowScene = windowScene
        
        let navController = UINavigationController()
        navController.navigationBar.isHidden = true
        coordinator = MainCoordinator(navigationController: navController)
        coordinator.start()
        
        
        appWindow.rootViewController = navController
        appWindow.makeKeyAndVisible()
        
        window = appWindow
    }
}

