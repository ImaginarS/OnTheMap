//
//  MainTabBarControllerViewController.swift
//  OnTheMap
//
//  Created by Sandra Q on 6/1/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
import FacebookLogin
import FacebookCore

class MainTabBarControllerViewController: UITabBarController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    var model = UserData.self
    var studentInfo: NewLocation?
    var objectID: UserInformation?
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        let request = GraphRequest(graphPath: "/me/permissions", parameters: [
            "fields": "id,name"
        ], httpMethod: HTTPMethod(rawValue: "DELETE"))
        request.start()
        OTMClient.logout {
            DispatchQueue.main.async {
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        let loginManager = LoginManager()
        loginManager.logOut()
    }
    
    @IBAction func addPin(_ sender: Any) {
        print(OTMClient.Auth.objectId)
        if OTMClient.Auth.objectId == "" {
            coordinator?.viewAddLocationVC()
        }
        else {
            alertDisplayOverwriteLocation()
        }
    }
    
}
