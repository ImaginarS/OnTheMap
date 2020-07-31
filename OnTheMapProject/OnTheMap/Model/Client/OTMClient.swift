//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Sandra Q on 5/18/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation


class OTMClient {
    
    var model: UserData?
    
    struct Auth {
        static var sessionId = ""
        static var userID = ""
        static var firstName = ""
        static var lastName = ""
        static var location = ""
        static var objectId = ""
        static var model: UserData?
    }
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case createSessionId
        case getUserData
        case getStudentsLocations
        case webSignUp
        case postLocation
        case updateLocation
        
        var stringValue: String {
            switch self {
                
                case .createSessionId: return Endpoints.base + "/session"
                case .getUserData: return Endpoints.base + "/users/" + Auth.userID
                //https://onthemap-api.udacity.com/v1/users/<user_id>
                case .getStudentsLocations: return Endpoints.base + "/StudentLocation?order=-updatedAt"
                case .webSignUp: return "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
                case .postLocation: return Endpoints.base + "/StudentLocation"
                case .updateLocation: return Endpoints.base + "/StudentLocation/\(Auth.objectId)"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void){
        let body = LoginRequest(udacity: SignIn(username: username, password: password))
        print(body)
        taskForPostRequest(url: Endpoints.createSessionId.url, responseType: SessionResponse.self, body: body) {
            (response, error)  in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.userID = response.account.key
                print(response.account.key)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    
    class func getPublicUserData(completion: @escaping (UserData?, Error?) -> Void) {
        let request = URLRequest(url: Endpoints.getUserData.url )
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let newData = data.dropFirst(5)
            guard let dataString = String(data: newData, encoding: .utf8) else { return }
            let jsonData = Data(dataString.utf8)
            
            let decoder = JSONDecoder()
            do {
                
                let userData = try decoder.decode(UserData.self, from: jsonData)
                Auth.firstName = userData.firstName
                Auth.lastName = userData.lastName
                Auth.location = (userData.location ?? "") ?? ""
                print(userData.key)
                print(userData.firstName)
                print(userData.lastName)
                //                    print(userData.location as Any)
                Auth.model = userData
                print(Auth.objectId)
                print(Auth.model?.firstName ?? "no first name")
                print(Auth.model?.lastName ?? "no last name")
                // return
                completion(userData, nil)
            } catch {
                //  completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func getStudentsLocations(completion: @escaping ([StudentLocation]?, Error?) -> Void){
        let request = URLRequest(url: Endpoints.getStudentsLocations.url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(Result.self, from: data)
                completion(result.results, nil)
            } catch {
                completion(nil,error)
            }
        }
        task.resume()
    }
    
    class func postStudentLocation(info: NewLocation, completion: @escaping (Bool, Error?) -> Void){
        let body = NewLocation(uniqueKey: info.uniqueKey, firstName: info.firstName, lastName: info.lastName, mapString: info.mapString, mediaURL: info.mediaURL, latitude: info.latitude, longitude: info.longitude)
        print(body)
        
        var request = URLRequest(url: Endpoints.postLocation.url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                completion(false, error)
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false,error)
                }
                return
            }
            
            guard let dataString = String(data: data, encoding: .utf8) else { return }
            let jsonData = Data(dataString.utf8)
            
            let decoder = JSONDecoder()
            do {
                let userData = try decoder.decode(UserInformation.self, from: jsonData)
                DispatchQueue.main.async {
                    Auth.objectId = userData.objectId
                    print(Auth.objectId)
                    
                    completion(true, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(UserInformation.self, from: jsonData) as! Error
                    DispatchQueue.main.async {
                        completion(false, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func updateStudentLocation(info: NewLocation, completion: @escaping (Bool, Error?) -> Void){
        let body = NewLocation(uniqueKey: info.uniqueKey, firstName: info.firstName, lastName: info.lastName, mapString: info.mapString, mediaURL: info.mediaURL, latitude: info.latitude, longitude: info.longitude)
        print(body)
        
        var request = URLRequest(url: Endpoints.updateLocation.url)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                completion(false, error)
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false,error)
                }
                return
            }
            
            guard let dataString = String(data: data, encoding: .utf8) else { return }
            let jsonData = Data(dataString.utf8)
            
            let decoder = JSONDecoder()
            do {
                let userData = try decoder.decode(UpdatedLocation.self, from: jsonData)
                DispatchQueue.main.async {
                    print(userData)
                    completion(true, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(UpdatedLocation.self, from: jsonData) as! Error
                    DispatchQueue.main.async {
                        completion(false, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    
    
    class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                completion(nil, error)
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil,error)
                }
                return
            }
            
            let newData = data.dropFirst(5)
            guard let dataString = String(data: newData, encoding: .utf8) else { return }
            let jsonData = Data(dataString.utf8)
            
            let decoder = JSONDecoder()
            do {
                let userData = try decoder.decode(ResponseType.self, from: jsonData)
                DispatchQueue.main.async {
                    completion(userData, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ResponseType.self, from: jsonData) as! Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func logout(completion: @escaping () -> Void)  {
        var request = URLRequest(url: Endpoints.createSessionId.url)
        
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            let range = data.dropFirst(5)
            
            guard String(data: range, encoding: .utf8) != nil else {
                return
            }
            completion()
        }
        task.resume()
    }
}

