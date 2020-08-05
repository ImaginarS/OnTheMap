//
//  AddLocationRequest.swift
//  OnTheMap
//
//  Created by Sandra Q on 7/6/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

// MARK: - NewLocation
struct NewLocation: Codable {
    let uniqueKey, firstName, lastName, mapString: String
    let mediaURL: String
    let latitude, longitude: Double
}

// MARK: - Updated Location
struct UpdatedLocation: Codable {
    let updatedAt: String
}

