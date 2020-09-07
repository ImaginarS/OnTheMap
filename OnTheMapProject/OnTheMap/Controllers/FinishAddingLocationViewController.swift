//
//  FinishAddingLocationViewController.swift
//  OnTheMap
//
//  Created by Sandra Q on 7/28/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class FinishAddingLocationViewController: UIViewController , Storyboarded{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addLocationMap: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    var studentInfo: NewLocation?
    var model: UserData?
    var savedObject: UserInformation?
    weak var coordinator: MainCoordinator?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callInProgress(false)
        if let studentLocation = studentInfo {
            showLocations(location: studentLocation)
        }
    }
    
    @IBAction func finishButton(_ sender: Any) {
        callInProgress(true)
        guard let studentInfo: NewLocation  = studentInfo else {
            return
        }
        
        if OTMClient.Auth.objectId == "" {
            OTMClient.postStudentLocation(info: studentInfo, completion: handleResponse(success: error:))
        } else {
            OTMClient.updateStudentLocation(info: studentInfo, completion: handleResponse(success:error:))
        }
    }
    
    func handleResponse(success: Bool, error: Error?) {
        callInProgress(false)
        if success {
            DispatchQueue.main.async {
                let mapVC = MainTabBarControllerViewController.instantiate()
                self.navigationController?.pushViewController(mapVC,animated: false)
            }
        }
        else {
            DispatchQueue.main.async {
                self.callInProgress(false)
                self.failToPostLocation()
            }            
        }
    }
    
    
    func callInProgress(_ locationPosting: Bool) {
        DispatchQueue.main.async {
            if locationPosting {
                self.finishButton.isEnabled = false
                self.activityIndicator.startAnimating()
            } else {
                self.finishButton.isEnabled = true
                self.activityIndicator.stopAnimating()
            }
            self.activityIndicator.hidesWhenStopped = true
        }
    }
    
    private func showLocations(location: NewLocation) {
        addLocationMap.removeAnnotations(addLocationMap.annotations)
        if let coordinate = extractCoordinate(location: location) {
            let annotation = MKPointAnnotation()
            annotation.title = location.mapString
            annotation.subtitle = location.mediaURL
            annotation.coordinate = coordinate
            addLocationMap.addAnnotation(annotation)
            addLocationMap.showAnnotations(addLocationMap.annotations, animated: true)
        }
    }
    
    private func extractCoordinate(location: NewLocation?) -> CLLocationCoordinate2D? {
        if let lat = location?.latitude, let lon = location?.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }
}

