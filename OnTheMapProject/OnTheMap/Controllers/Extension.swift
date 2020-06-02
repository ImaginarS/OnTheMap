//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Sandra Q on 6/1/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

class TabBar: UITabBarController {
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        OTMClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}


