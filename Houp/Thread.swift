//
//  Thread.swift
//  Houp
//
//  Created by Sebastian on 19.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

class Thread: NSObject, NSCoding{
    
    var rev: String?
    var tid: String?
    var originalID: String?
    var authorID: String?
    var userName: String?
    var groupID: String?
    var title: String?
    var message: String?
    var dateString: String?
    var dateObject: Date?
    var commentIDs: [String]?
    var hasBeenUpdated: Bool = false
    
    
    init(rev: String?, tid: String?, originalID: String?, authorID: String?, authorUsername: String? ,groupID: String?,title: String?, message: String? ,date: Date?, dateString: String?, commentIDs: [String]?) {
        
        if let revision = rev {
            self.rev = revision
        }
        if let ID = tid {
            self.tid = ID
        }
        if let adID = authorID {
            self.authorID = adID
        }
        if let oriID = originalID {
            self.originalID = oriID
        }
        if let username = authorUsername {
            self.userName = username
        }
        if let group = groupID {
            self.groupID = group
        }
        if let tit = title {
            self.title = tit
        }
        if let mess = message {
            self.message = mess
        }
        if let dateOb = date{
        self.dateObject = dateOb
        }
        
        if let dat = date{
        let dateformatter = DateFormatter()
          dateformatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        self.dateString = dateformatter.string(from: dat)
        }
        
        if let datStr = dateString{
            self.dateString = datStr
            self.dateObject = Date(dateString: datStr)
        }
        
        if let comments = commentIDs {
            self.commentIDs = comments
        }
    }
    
    convenience init(props: [String: Any]){
        self.init(rev: props["_rev"] as? String, tid: props["_id"] as? String,originalID: props["originalID"] as? String, authorID: props["authorID"] as? String, authorUsername: nil, groupID: props["groupID"] as? String, title: props["title"] as? String, message: props["message"] as? String, date: nil, dateString: props["date"] as? String , commentIDs: props["commentIDs"] as? [String])
    }
    
    required init(coder aDecoder: NSCoder) {
        if let _rev = aDecoder.decodeObject(forKey: "rev") as? String{
            self.rev = _rev
        }
        if let ID = aDecoder.decodeObject(forKey: "tid") as? String{
            self.tid = ID
        }
        if let adID = aDecoder.decodeObject(forKey: "authorID") as? String{
            self.authorID = adID
        }
        if let oriID = aDecoder.decodeObject(forKey: "originalID") as? String{
            self.originalID = oriID
        }
        if let username = aDecoder.decodeObject(forKey: "username") as? String{
            self.userName = username
        }
        if let group = aDecoder.decodeObject(forKey: "groupID") as? String{
            self.groupID = group
        }
        if let tit = aDecoder.decodeObject(forKey: "title") as? String{
            self.title = tit
        }
        if let mess = aDecoder.decodeObject(forKey: "message") as? String{
            self.message = mess
        }
        if let dateOb = aDecoder.decodeObject(forKey: "dateObject") as? Date{
            self.dateObject = dateOb
        }
        if let comments = aDecoder.decodeObject(forKey: "commentIDs") as? [String]{
            self.commentIDs = comments
        }
        if let update = aDecoder.decodeBool(forKey: "hasBeenUpdated") as? Bool{
            self.hasBeenUpdated = update
        }
        if let dateStr = aDecoder.decodeObject(forKey: "dateString") as? String{
            self.dateString = dateStr
        }
    }
    
    func encode(with aCoder: NSCoder) {
        if let _rev = self.rev {
            aCoder.encode(_rev, forKey: "rev")
        }
        if let ID = self.tid {
            aCoder.encode(ID, forKey: "tid")
        }
        if let oriID = self.originalID {
            aCoder.encode(oriID, forKey: "originalID")
        }
        if let aID = self.authorID {
            aCoder.encode(aID, forKey: "authorID")
        }
        if let username = self.userName {
            aCoder.encode(username, forKey: "username")
        }
        if let group = self.groupID {
            aCoder.encode(group, forKey: "groupID")
        }
        if let tit = self.title {
            aCoder.encode(tit, forKey: "title")
        }
        if let mess = self.message {
            aCoder.encode(mess, forKey: "message")
        }
        if let dateOb = self.dateObject {
            aCoder.encode(dateOb, forKey: "dateObject")
        }
        if let comments = self.commentIDs {
            aCoder.encode(comments, forKey: "commentIDs")
        }
        
        aCoder.encode(self.hasBeenUpdated, forKey: "hasBeenUpdated")
 
        if let dateStr = self.dateString {
            aCoder.encode(dateStr, forKey: "dateString")
        }
    }
    func getPropertyPackageCreateThreadWithOriginalID() -> [String: Any]{
        var properties = [String: Any]()
        
        properties["type"] = "Thread"
        properties["commentIDs"] = [String]()
        
        if let group = self.groupID {
            properties["groupID"] = group
        }
        if let oriID = self.originalID {
            properties["originalID"] = oriID
        }
        if let aID = self.authorID {
            properties["authorID"] = aID
        }
        if let aUserName = self.userName {
            properties["authorUsername"] = aUserName
        }
        
        if let tit = self.title {
            properties["title"] = tit
        }
        if let mess = self.message {
            properties["message"] = mess
        }
        if let dat = self.dateString{
            properties["date"] = dat
        }
        return properties
    }
    
    
    func getPropertyPackageCreateThreadWithoutOriginalID() -> [String: Any]{
        var properties = [String: Any]()
        
        properties["type"] = "Thread"
        properties["commentIDs"] = [String]()
        properties["originalID"] = [String]()
        
        if let group = self.groupID {
            properties["groupID"] = group
        }
        if let aID = self.authorID {
            properties["authorID"] = aID
        }
        if let aUserName = self.userName {
            properties["authorUsername"] = aUserName
        }

        if let tit = self.title {
            properties["title"] = tit
        }
        if let mess = self.message {
            properties["message"] = mess
        }
        if let dat = self.dateString{
            properties["date"] = dat
        }
        return properties
    }
}
