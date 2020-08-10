//
//  MainCoordinator.swift
//  OnTheMap
//
//  Created by Sandra Q on 7/31/20.
//  Copyright © 2020 DevTrain. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        DispatchQueue.main.async {
            let loginVC = LoginViewController.instantiate()
            loginVC.coordinator = self
            self.navigationController.setNavigationBarHidden(true, animated: false)
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
            self.navigationController.setNavigationBarHidden(false, animated: false)
            self.navigationController.pushViewController(tabBarVC,animated: false)
        }
    }

    func getFacebookData() {
        DispatchQueue.main.async {
            
            if AccessToken.current != nil {
                let tokenString = String(describing: AccessToken.current?.tokenString)
                print(tokenString)
                
                GraphRequest(graphPath: "me", parameters: ["fields": "name"]).start { (connection, result, error) in
                    if error == nil {
                        let dict = result as! [String: AnyObject] as NSDictionary
                        let name = dict.object(forKey: "name") as! String
                        self.viewStudentsLocations()
                        OTMClient.Auth.firstName = name
                    } else {
                        print(error?.localizedDescription ?? error ?? "")
                    }
                }
                
            }
        }
    }
    
    
}



