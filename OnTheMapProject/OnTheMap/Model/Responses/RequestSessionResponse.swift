//
//  RequestSessionResponse.swift
//  OnTheMap
//
//  Created by Sandra Q on 5/18/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct SessionResponse: Codable {
    let account: Account
    let session: Session
    
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
