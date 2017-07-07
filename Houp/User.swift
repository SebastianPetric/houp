//
//  User.swift
//  Houp
//
//  Created by Sebastian on 22.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

class User{
   
    static let shared: User = User()
    
    var uid: String?
    var username: String?
    var prename: String?
    var name: String?
    var email: String?
    var password: String?
    var gender: Int?
    var birthday: Date?
    var profileImage: Data?
    var groupIDs: [String] = [String]()
    var dailyFormIDs: [String] = [String]()
    var weeksOfActivityIDs: [String] = [String]()

    func getPropertyPackageForRegistration() -> [String: Any]{
        var properties = [String: Any]()
        
        properties["type"] = "User"
        properties["groupIDs"] = [String]()
        properties["dailyFormIDs"] = [String]()
        properties["weeksOfActivityIDs"] = [String]()
        
        if let username = self.username {
            properties["username"] = username
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
           //properties["gender"] = String(gender)
            properties["gender"] = gender
        }
        if let birthday = self.birthday {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd MM YYYY"
            properties["birthday"] = dateformatter.string(from: birthday)
        }
        return properties
    }
    
    func isOwner(id: String) -> Bool{
        return self.uid == id
    }
    
    func getUserID() -> String{
        return self.uid!
    }
}
