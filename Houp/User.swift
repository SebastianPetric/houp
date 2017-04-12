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
    var groupIDs: [String] = []
    var DailyFormIDs: [String]?
    var weeksOfActivity: [String]?
    
    func getPropertyPackageForRegistration() -> [String: String]{
        var properties = [String: String]()
        
        properties["type"] = "User"
        
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
           properties["gender"] = String(gender)
        }

        if let birthday = self.birthday {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd MM YYYY"
            properties["birthday"] = dateformatter.string(from: birthday)
        }
        return properties
    }
    
}
