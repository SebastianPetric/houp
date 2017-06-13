//
//  Comment.swift
//  Houp
//
//  Created by Sebastian on 26.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

class Comment: NSObject, NSCoding{
    
    var rev: String?
    var cid: String?
    var authorID: String?
    var userName: String?
    var groupID: String?
    var threadID: String?
    var message: String?
    var dailyActivityID: String?
    var dateString: String?
    var dateObject: Date?
    var likeIDs: [String]?
    var hasBeenUpdated = false
    
    
    init(rev: String?, cid: String?, authorID: String?, authorUsername: String?, groupID: String?, dailyActivityID: String?,threadID: String?, message: String? ,date: Date?, dateString: String? ,likeIDs: [String]?) {
        
        if let revision = rev {
            self.rev = revision
        }
        if let ID = cid {
            self.cid = ID
        }
        if let adID = authorID {
            self.authorID = adID
        }
        if let username = authorUsername {
            self.userName = username
        }
        if let group = groupID {
            self.groupID = group
        }
        if let daily = dailyActivityID {
            self.dailyActivityID = daily
        }
        if let thread = threadID {
            self.threadID = thread
        }
        if let mess = message {
            self.message = mess
        }
        
        if let dat = date{
            self.dateObject = dat
            self.dateString = dat.getDateTimeFormatted()
        }
        
        if let dateStr = dateString{
        self.dateString = dateStr
        self.dateObject = Date(dateString: dateStr)
        }
        
        if let likes = likeIDs {
            self.likeIDs = likes
        }
    }
    
    convenience init(propsForThread: [String: Any]) {
        self.init(rev: propsForThread["_rev"] as? String, cid: propsForThread["_id"] as? String, authorID: propsForThread["authorID"] as? String, authorUsername: nil, groupID: propsForThread["groupID"] as? String,dailyActivityID: nil,threadID: propsForThread["threadID"] as? String, message: propsForThread["message"] as? String, date: nil, dateString: propsForThread["date"] as? String, likeIDs: propsForThread["likeIDs"] as? [String])
    }
    
    convenience init(propsForActivity: [String: Any]) {
        self.init(rev: propsForActivity["_rev"] as? String, cid: propsForActivity["_id"] as? String, authorID: propsForActivity["authorID"] as? String, authorUsername: nil, groupID: propsForActivity["groupID"] as? String,dailyActivityID: propsForActivity["dailyActivityID"] as? String,threadID: nil, message: propsForActivity["message"] as? String, date: nil, dateString: propsForActivity["date"] as? String, likeIDs: propsForActivity["likeIDs"] as? [String])
    }

    
    required init(coder aDecoder: NSCoder) {
        if let _rev = aDecoder.decodeObject(forKey: "rev") as? String{
            self.rev = _rev
        }
        if let ID = aDecoder.decodeObject(forKey: "cid") as? String{
            self.cid = ID
        }
        if let adID = aDecoder.decodeObject(forKey: "authorID") as? String{
            self.authorID = adID
        }
        if let username = aDecoder.decodeObject(forKey: "username") as? String{
            self.userName = username
        }
        if let group = aDecoder.decodeObject(forKey: "groupID") as? String{
            self.groupID = group
        }
        if let daily = aDecoder.decodeObject(forKey: "dailyActivityID") as? String{
            self.dailyActivityID = daily
        }
        if let thread = aDecoder.decodeObject(forKey: "threadID") as? String{
            self.threadID = thread
        }
        if let mess = aDecoder.decodeObject(forKey: "message") as? String{
            self.message = mess
        }
        if let dateOb = aDecoder.decodeObject(forKey: "dateObject") as? Date{
            self.dateObject = dateOb
        }
        if let likes = aDecoder.decodeObject(forKey: "likeIDs") as? [String]{
            self.likeIDs = likes
        }
        if let update = aDecoder.decodeObject(forKey: "hasBeenUpdated") as? Bool{
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
        if let ID = self.cid {
            aCoder.encode(ID, forKey: "cid")
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
        if let daily = self.dailyActivityID {
            aCoder.encode(daily, forKey: "dailyActivityID")
        }
        if let thread = self.threadID {
            aCoder.encode(thread, forKey: "threadID")
        }
        if let mess = self.message {
            aCoder.encode(mess, forKey: "message")
        }
        if let dateOb = self.dateObject {
            aCoder.encode(dateOb, forKey: "dateObject")
        }
        if let likes = self.likeIDs {
            aCoder.encode(likes, forKey: "likeIDs")
        }
        
        aCoder.encode(hasBeenUpdated, forKey: "hasBeenUpdated")
        
        if let dateStr = self.dateString {
            aCoder.encode(dateStr, forKey: "dateString")
        }
    }
    
    
    
    func getPropertyPackageCreateComment() -> [String: Any]{
        var properties = [String: Any]()
        
        properties["type"] = "Comment"
        properties["likeIDs"] = [String]()
        
        if let group = self.groupID {
            properties["groupID"] = group
        }
        
        if let daily = self.dailyActivityID {
            properties["dailyActivityID"] = daily
        }
        if let aID = self.authorID {
            properties["authorID"] = aID
        }
        if let aUserName = self.userName {
            properties["authorUsername"] = aUserName
        }
        
        if let thread = self.threadID {
            properties["threadID"] = thread
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
