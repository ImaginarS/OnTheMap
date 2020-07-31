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

class FinishAddingLocationViewController: UIViewController {
    
    @IBOutlet weak var addLocationMap: MKMapView!
    var studentInfo: NewLocation?
    var model: UserData?
    var savedObject: UserInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let studentLocation = studentInfo {
            showLocations(location: studentLocation)
        }
    }
    
    @IBAction func finishButton(_ sender: Any) {
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
        if success {
            DispatchQueue.main.async {
                let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                self.present(mapVC, animated: true, completion: nil)
            }
        }
        else {
            
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

