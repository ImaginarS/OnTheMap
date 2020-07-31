//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Sandra Q on 5/18/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    var location: LocationsStore?
    
    //MARK: - IBOutlets
    @IBOutlet private var mapView: MKMapView!
    
    //MARK: - UIViewController life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        OTMClient.getStudentsLocations() {(result, error) in
            DispatchQueue.main.async {
                if error != nil {
                    let alert = UIAlertController(title: "Fail", message: "sorry, we could not fetch data", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    print("error")
                    return
                }
                
                guard let result = result else {
                    return
                }
                let map = self.markMap(withLocations: result)
                self.mapView.addAnnotations(map)
            }
        }
    }
    
    
    func markMap(withLocations studentLocations: [StudentLocation]) ->
        [MKPointAnnotation] {
            return studentLocations.map { (location) -> MKPointAnnotation in
                
                let long = CLLocationDegrees(location.longitude )
                let lat = CLLocationDegrees(location.latitude )
                let cords = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let mediaURL = location.mediaURL
                let firstName = location.firstName
                let lastName = location.lastName
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = cords
                annotation.title = "\(String(describing: firstName)) \(String(describing: lastName))"
                annotation.subtitle = mediaURL
                return annotation
            }
    }
    
    // MARK: - MKMapViewDelegate
    
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let url = URL(string: (view.annotation?.subtitle ?? "") ?? ""){
                UIApplication.shared.open(url)
            }
        }
    }
}
