//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Sandra Q on 6/8/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddLocationViewController: UIViewController, UITextFieldDelegate, Storyboarded {
    weak var coordinator: MainCoordinator?
    var objectId: String?
    var model: UserData?
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var enterWebsiteLink: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationText.delegate = self
        enterWebsiteLink.delegate = self
        model = OTMClient.Auth.model
        
        if OTMClient.Auth.objectId == "" {
            OTMClient.getPublicUserData() {result,error in
                OTMClient.Auth.model = result
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func findLocationButton(_ sender: Any) {
        guard let newLocation = locationText.text else {
            return
        }
        geocodePosition(location: newLocation)
    }
    
    private func geocodePosition(location: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (newMarker, error) in
            
            self.processResponse(withPlacemarks: newMarker, error: error)
        }
    }
    
    private func processResponse(withPlacemarks newMarker: [CLPlacemark]?, error: Error?) {
        if error != nil {
            locationFinderFailureAlert()
            return
        } else {
            var location: CLLocation?
            if let marker = newMarker, marker.count > 0 {
                location = marker.first?.location
            }
            if let location = location {
                self.loadNewLocation(location.coordinate)
            } else {
                locationText.text = "No Matching Location Found"
            }
        }
    }
    
    private func loadNewLocation(_ coordinate: CLLocationCoordinate2D) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "FinishAddingLocationViewController") as! FinishAddingLocationViewController

        controller.studentInfo = buildUserInfo(coordinate)
        
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func buildUserInfo(_ coordinate: CLLocationCoordinate2D) -> NewLocation {
        let userInfo = NewLocation.init(uniqueKey: OTMClient.Auth.userID, firstName: OTMClient.Auth.firstName, lastName: OTMClient.Auth.lastName, mapString: locationText.text!, mediaURL: enterWebsiteLink.text!, latitude: coordinate.latitude, longitude: coordinate.longitude)
        return userInfo
    }
    
    func locationFinderFailureAlert(){
        let alertVC = UIAlertController(title: "Unable to find a location with that name", message: "", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: false, completion: nil)
    }
}
