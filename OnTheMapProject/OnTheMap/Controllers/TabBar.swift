//
//  TabBar.swift
//  OnTheMap
//
//  Created by Sandra Q on 6/1/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
import FacebookLogin

class MainTabBarControllerViewController: UITabBarController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    var model = UserData.self
    var studentInfo: NewLocation?
    var objectID: UserInformation?
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        
        OTMClient.logout {
            DispatchQueue.main.async {
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                self.navigationController?.popToRootViewController(animated: true)
                let loginManager = LoginManager()
                loginManager.logOut()
            }
        }
    }
    
    
    @IBAction func addPin(_ sender: Any) {
        print(OTMClient.Auth.objectId)
        if OTMClient.Auth.objectId == "" {
            coordinator?.viewAddLocationVC()
        }
            
        else {
            let alert = UIAlertController(title: "", message: "You have already posted a student location. Would you like to overwrite the location?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Overwrite", style: UIAlertAction.Style.destructive, handler:  { action in
                DispatchQueue.main.async {
                    let addLocationVC = AddLocationViewController.instantiate()
                     self.navigationController?.pushViewController(addLocationVC,animated: true)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
