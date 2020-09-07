//
//  Extensions.swift
//  OnTheMap
//
//  Created by Sandra Q on 8/2/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

extension String {
    var isValidURL: Bool {

        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}

extension UIViewController {
    func alertDisplayLoginFailure(){
        let alertVC = UIAlertController(title: "Login failed. Check your credentials and try again", message: "", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func alertDisplayOverwriteLocation(){
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
    
    func failToPostLocation() {
        let alertVC = UIAlertController(title: "Post Location Fail", message: "", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func displayStudentLocationsNotFound(){
        let alert = UIAlertController(title: "Fail", message: "sorry, we could not fetch data", preferredStyle: .alert)
                           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }

}
