//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Sandra Q on 5/18/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation


class OTMClient {
    
    struct Auth {
        static var sessionId = ""
    }
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case createSessionId
        case getUserData
        case getStudentsLocations
        case webSignUp
        
        var stringValue: String {
            switch self {
                
                case .createSessionId: return Endpoints.base + "/session"
                case .getUserData: return Endpoints.base + "/users/" + Auth.sessionId
                case .getStudentsLocations: return Endpoints.base + "/StudentLocation?order=-updatedAt"
                case .webSignUp: return "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
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
                print("fail")
            }
        }
        task.resume()
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void){
        let body = LoginRequest(udacity: SignIn(username: username, password: password))
        print(body)
        taskForPostRequest(url: Endpoints.createSessionId.url, responseType: SessionResponse.self, body: body) {
            (response, error)  in
            if let response = response {
                 Auth.sessionId = response.session.id
                print(Auth.sessionId)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getPublicUserData(completion: @escaping (Bool, Error?) -> Void) {
            let request = URLRequest(url: Endpoints.getUserData.url )
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    completion(false, error)
                    return
                }
                
                let newData = data.dropFirst(5)
                guard let dataString = String(data: newData, encoding: .utf8) else { return }
                let jsonData = Data(dataString.utf8)
                
                let decoder = JSONDecoder()
                do {
                    let responseObject = try decoder.decode(UserInformation.self, from: jsonData)
                    print(responseObject)
                } catch {
                    completion(false, error)
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
                let responseObject = try decoder.decode(ResponseType.self, from: jsonData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
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
        
       // let body = LogoutRequest(session: SignOut(id: Auth.sessionId, expiration: ""))
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

