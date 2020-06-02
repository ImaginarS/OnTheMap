//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Sandra Q on 5/21/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    //var locations: [Result] = []
    

    
     
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
                    print("Shit don't add up")
                    return
                }
                // The "locations" array is an array of dictionary objects that are similar to the JSON
                // data that you can download from parse.
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
            //pinView!.leftCalloutAccessoryView = UIButton(type: .detailDisclosure)
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



//func handleSessionResponse(locations: [StudentLocation]?, error: Error?) {
//  
//        DispatchQueue.main.async {
//            // The "locations" array is an array of dictionary objects that are similar to the JSON
//            // data that you can download from parse.
//            
//            let locations: [StudentLocation] = []
//            
//            
//            
//            // We will create an MKPointAnnotation for each dictionary in "locations". The
//            // point annotations will be stored in this array, and then provided to the map view.
//            
//            var annotations = [MKPointAnnotation]()
//            
//            // The "locations" array is loaded with the sample data below. We are using the dictionaries
//            // to create map annotations. This would be more stylish if the dictionaries were being
//            // used to create custom structs. Perhaps StudentLocation structs.
//            
//            for locations in locations {
//                
//                // Notice that the float values are being used to create CLLocationDegree values.
//                // This is a version of the Double type.
//                let long = CLLocationDegrees(locations.longitude )
//                let lat = CLLocationDegrees(locations.latitude )
//                let cords = CLLocationCoordinate2D(latitude: lat, longitude: long)
//                let mediaURL = locations.mediaURL
//                let firstName = locations.firstName
//                let lastName = locations.lastName
//                
//
//                
//                // Here we create the annotation and set its coordiate, title, and subtitle properties
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = cords
//                annotation.title = "\(firstName) \(lastName)"
//                annotation.subtitle = mediaURL
//                
//                // Finally we place the annotation in an array of annotations.
//                annotations.append(annotation)
//            }
//    }
//}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//private extension MKMapView {
//    func centerToLocation(
//        _ location: CLLocation,
//        regionRadius: CLLocationDistance = 1000
//    ) {
//        let coordinateRegion = MKCoordinateRegion(
//            center: location.coordinate,
//            latitudinalMeters: regionRadius,
//            longitudinalMeters: regionRadius)
//        setRegion(coordinateRegion, animated: true)
//    }
//}
