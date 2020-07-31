//
//  LogoutRequest.swift
//  OnTheMap
//
//  Created by Sandra Q on 6/2/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

// MARK: - LogoutRequest
struct LogoutRequest: Codable {
    let session: SignOut
}

// MARK: - SignOut
struct SignOut: Codable {
    let id: String
    let expiration: String
}

