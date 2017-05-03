//
//  UserObject.swift
//  Houp
//
//  Created by Sebastian on 18.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

class UserObject: NSObject, NSCoding {
    var rev: String?
    var uid: String?
    var email: String?
    var userName: String?
    var prename: String?
    var name: String?
    var hasBeenUpdated = false
    
    
    init(rev: String?, uid: String?,email: String?, userName: String?, prename: String? ,name: String?) {
        
        if let revision = rev {
            self.rev = revision
        }
        if let ID = uid {
            self.uid = ID
        }
        if let username = userName {
            self.userName = username
        }
        if let mail = email {
            self.email = mail
        }
        if let nam = name {
            self.name = nam
        }
        if let pren = prename {
            self.prename = pren
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        if let _rev = aDecoder.decodeObject(forKey: "rev") as? String{
            self.rev = _rev
        }
        if let ID = aDecoder.decodeObject(forKey: "uid") as? String{
            self.uid = ID
        }
        if let username = aDecoder.decodeObject(forKey: "username") as? String{
            self.userName = username
        }
        if let mail = aDecoder.decodeObject(forKey: "email") as? String{
            self.email = mail
        }
        if let nam = aDecoder.decodeObject(forKey: "name") as? String{
            self.name = nam
        }
        if let pren = aDecoder.decodeObject(forKey: "prename") as? String{
            self.prename = pren
        }
    }
    
    func encode(with aCoder: NSCoder) {
        if let _rev = self.rev {
            aCoder.encode(_rev, forKey: "rev")
        }
        if let ID = self.uid {
            aCoder.encode(ID, forKey: "uid")
        }
        if let username = self.userName {
            aCoder.encode(username, forKey: "username")
        }
        if let nam = self.name {
            aCoder.encode(nam, forKey: "name")
        }
        if let pren = self.prename {
            aCoder.encode(pren, forKey: "prename")
        }
        if let mail = self.email {
            aCoder.encode(mail, forKey: "email")
        }
    }
}
