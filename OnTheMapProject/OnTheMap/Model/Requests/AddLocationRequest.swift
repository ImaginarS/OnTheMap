//
//  AddLocationRequest.swift
//  OnTheMap
//
//  Created by Sandra Q on 7/6/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newLocation = try? newJSONDecoder().decode(NewLocation.self, from: jsonData)

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

