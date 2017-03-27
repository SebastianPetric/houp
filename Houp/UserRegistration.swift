//
//  User.swift
//  Houp
//
//  Created by Sebastian on 22.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

class UserRegistration{
   
    static let shared: UserRegistration = UserRegistration()
    
    var username: String?
    var prename: String?
    var name: String?
    var email: String?
    var password: String?
    var gender: Int?
    var birthday: Date?
    var profileImage: Data?
    
    func getPropertyPackage() -> [String: String]{
        var properties = [String: String]()
        
        properties["type"] = "User"
        
        if let username = self.username {
            properties["username"] = username
            //properties?.updateValue(username, forKey: "username")
        }
        if let prename = self.prename {
            properties["prename"] = prename
        }
        if let name = self.name {
           properties["name"] = name
        }
        if let email = self.email {
           properties["email"] = email
        }
        if let password = self.password {
            properties["password"] = password
        }
        if let gender = self.gender {
           properties["gender"] = String(gender)
        }
        if let birthday = self.birthday {
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd MM YYYY"
            properties["birthday"] = dateformatter.string(from: self.birthday!)
        }
        /*let properties = [
            "type": "User",
            "name": "Sebastian",
            "email": "sebastian@gmail.com",
            "repo": "swift-couchbaselite-cheatsheet"
        ]*/
        return properties
    }
    
}
