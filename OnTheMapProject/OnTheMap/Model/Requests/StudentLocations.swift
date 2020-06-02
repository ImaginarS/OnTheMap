//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Sandra Q on 5/21/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct Result: Codable {
    let results: [StudentLocation]?
}

struct StudentLocation: Codable {
    static var lastFetched: [StudentLocation]?
    
    let firstName: String
    let lastName: String
    let longitude: Float
    let latitude: Float
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let createdAt: String
    let updatedAt: String
    
}

