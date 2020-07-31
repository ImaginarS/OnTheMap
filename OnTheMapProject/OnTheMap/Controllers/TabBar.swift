//
//  TabBar.swift
//  OnTheMap
//
//  Created by Sandra Q on 6/1/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import FacebookLogin

class TabBar: UITabBarController {
    
    var model = UserData.self
    var studentInfo: NewLocation?
    var objectID: UserInformation?
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        
        let loginManager = LoginManager()
        loginManager.logOut()
        
        OTMClient.logout {
            DispatchQueue.main.async {
                let loginScreenViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! UIViewController
                self.dismiss(animated: true, completion: nil)
                self.present(loginScreenViewController, animated: true, completion: nil)
                
            }
        }
    }
    
    @IBAction func addPin(_ sender: Any) {
        print(OTMClient.Auth.objectId)
        if OTMClient.Auth.objectId == "" {
            DispatchQueue.main.async {
                let addLocationVC = self.storyboard?.instantiateViewController(withIdentifier: "Add Location Navigation Controller") as! UINavigationController
                self.present(addLocationVC, animated: true, completion: nil)
                
            }
        }
            
        else {
            let alert = UIAlertController(title: "My Title", message: "You have currently posted a student location. Would you like to overite the student location?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Overwrite", style: UIAlertAction.Style.default, handler:  { action in
                DispatchQueue.main.async {
                    let addLocationVC = self.storyboard?.instantiateViewController(withIdentifier: "Add Location Navigation Controller") as! UINavigationController
                    self.present(addLocationVC, animated: true, completion: nil)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleSessionResponse(userData: UserData, error: Error?) {
        if error != nil {
            DispatchQueue.main.async {
                print(error?.localizedDescription ?? "There was an error")
            }
        }else {
            DispatchQueue.main.async {
                let addLocationVC = self.storyboard?.instantiateViewController(withIdentifier: "Add Location Navigation Controller") as! UINavigationController
                self.present(addLocationVC, animated: true, completion: nil)
                
            }
        }
    }
    
}
