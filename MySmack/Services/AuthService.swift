//
//  AuthService.swift
//  MySmack
//
//  Created by Michael Sidoruk on 30.01.2020.
//  Copyright © 2020 Michael Sidoruk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    static let shared = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    private init() {}
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()

        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func logInUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do {
                    let json = try JSON(data: data)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                    self.isLoggedIn = true
                } catch {
                    print(error.localizedDescription)
                }
                
                self.isLoggedIn = true
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func createUser(userName: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "name": userName,
            "email": lowerCaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor,
        ]
        
        Alamofire.request(URL_ADD_USER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do {
                    let json = try JSON(data: data)
                    self.setUserInfo(json: json)
                    completion(true)
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func findUserByEmail(completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do {
                    let json = try JSON(data: data)
                    self.setUserInfo(json: json)
                    completion(true)
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func setUserInfo(json: JSON) {
        let id = json["_id"].stringValue
        let color = json["avatarColor"].stringValue
        let avatarName = json["avatarName"].stringValue
        let email = json["email"].stringValue
        let name = json["name"].stringValue
        UserDataService.shared.setUserData(id: id, avatarColor: color, avatarName: avatarName, email: email, name: name)
    }
}
