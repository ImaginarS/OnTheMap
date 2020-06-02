//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Sandra Q on 5/18/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: SignIn
}
struct SignIn: Codable {
    let username: String
    let password: String
}

