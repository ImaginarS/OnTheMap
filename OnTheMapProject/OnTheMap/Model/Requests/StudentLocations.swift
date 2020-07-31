//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Sandra Q on 5/21/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

// MARK: - Result
struct Result: Codable {
    let results: [StudentLocation]
}

// MARK: - ResultElement
struct StudentLocation: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude, longitude: Float
    let mapString, mediaURL, objectId, uniqueKey, updatedAt: String
}

struct LocationsStore {
    var lastFetched: [StudentLocation]?
}





