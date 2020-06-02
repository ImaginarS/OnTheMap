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

    @IBOutlet weak var mapView: MKMapView!
        
//    @objc func startOver() {
//        if let navigationController = self.navigationController {
//            navigationController.popToRootViewController(animated: true)
//        }
//    }
     
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
                
                StudentLocation.lastFetched = result
                var map = [MKPointAnnotation]()
                
                guard let result = result else {
                    return
                }

                for location in result{
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
                    map.append(annotation)
                }
                self.mapView.addAnnotations(map)
            }}
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
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let url = URL(string: (view.annotation?.subtitle ?? "") ?? ""){
                UIApplication.shared.open(url)
            }
        }
    }
    
    
}
