//
//  LocationViewController.swift
//  OnTheMap
//
//  Created by Sandra Q on 5/18/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class LocationListViewController: UITableViewController, Storyboarded  {
    
    weak var coordinator: MainCoordinator?
    var location = LocationsStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        OTMClient.getStudentsLocations() {(result, error) in
            if error != nil {
                self.displayStudentLocationsNotFound()
            }
            DispatchQueue.main.async {
                self.location.lastFetched = result
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return location.lastFetched?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        
        let locations = location.lastFetched?[indexPath.row]
        cell.textLabel?.text = "\(locations?.firstName ?? "") \(locations?.lastName ?? "")"
        cell.detailTextLabel?.text = "\(locations?.mapString ?? "")     URL:\(locations?.mediaURL ?? "")"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locations = location.lastFetched?[indexPath.row]
        let mediaUrl = locations?.mediaURL
        
        if let mediaUrl = mediaUrl {
            guard let url = URL(string: mediaUrl) else {
                return
            }
            if  UIApplication.shared.canOpenURL(url) == true {
                UIApplication.shared.open(url)
            } else {
                print("can't open \(url)")
            }
        }
    }
}


