//
//  MainCoordinator.swift
//  OnTheMap
//
//  Created by Sandra Q on 7/31/20.
//  Copyright © 2020 DevTrain. All rights reserved.
//

import UIKit

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        

    }
    
    func start() {

        DispatchQueue.main.async {
            let loginVC = LoginViewController.instantiate()
            loginVC.coordinator = self
            loginVC.navigationController?.navigationBar.isHidden = true
            self.navigationController.pushViewController(loginVC,animated: false)
           
        }
    }
    
    func viewAddLocationVC() {
        DispatchQueue.main.async {
            let AddlocationVC = AddLocationViewController.instantiate()
            AddlocationVC.coordinator = self
            self.navigationController.setNavigationBarHidden(false, animated: false)
            self.navigationController.pushViewController(AddlocationVC,animated: false)
        }
    }
    
    func viewStudentsLocations() {

        DispatchQueue.main.async {
            let tabBarVC = MainTabBarControllerViewController.instantiate()
            tabBarVC.coordinator = self
            self.navigationController.navigationBar.isHidden = false
            self.navigationController.pushViewController(tabBarVC,animated: false)
        }
    }
}
