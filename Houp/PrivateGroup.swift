//
//  PrivateGroup.swift
//  Houp
//
//  Created by Sebastian on 29.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation


class PrivateGroup: NSObject, NSCoding{
   


    var pgid: String?
    var adminID: String?
    var nameOfGroup: String?
    var secretID: String?
    var location: String?
    var dayOfMeeting: String?
    var timeOfMeeting: Date?
    var timeOfMeetingString: String?
    var threadIDs: [String]?
    var threads: [Thread]?
    var memberIDs: [String]?
    var groupRequestIDs: [String]?
    var dailyActivityIDs: [String]?
    var hasBeenUpdated = false
    var createdAt: Date?
    var createdAtString: String?

    init(pgid: String?, adminID: String?,nameOfGroup: String?,location: String?, dayOfMeeting: String? ,timeOfMeeting: Date?,timeOfMeetingString: String?, secretID: String?, threadIDs: [String]?, memberIDs: [String]?, dailyActivityIDs: [String]?, groupRequestIDs: [String]?, createdAt: Date?, createdAtString: String?) {
     
        if let ID = pgid {
            self.pgid = ID
        }
         
        if let adID = adminID {
            self.adminID = adID
        }
        if let nameGroup = nameOfGroup {
            self.nameOfGroup = nameGroup
        }
        if let loc = location {
            self.location = loc
        }
        if let dayMeeting = dayOfMeeting {
            self.dayOfMeeting = dayMeeting
        }
        
        if let secret = secretID{
        self.secretID = secret
        }
        
        if let timeMeeting = timeOfMeeting {
            self.timeOfMeeting = timeMeeting
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "HH:mm"
            self.timeOfMeetingString = dateformatter.string(from: timeMeeting)
        }
        
        if let timeOfMeetingStr = timeOfMeetingString{
            self.timeOfMeetingString = timeOfMeetingStr
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            self.timeOfMeeting = formatter.date(from: timeOfMeetingStr)
        }
        
        if let threads = threadIDs {
            self.threadIDs = threads
        }
        
        if let members = memberIDs {
            self.memberIDs = members
        }
        
        if let dailyActivities = dailyActivityIDs {
            self.dailyActivityIDs = dailyActivities
        }
        if let groupRequests = groupRequestIDs {
            self.groupRequestIDs = groupRequests
        }
        
        if let created = createdAt {
            self.createdAt = created
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
            self.createdAtString = dateformatter.string(from: Date())
        }
        
        if let createdStr = createdAtString{
            self.createdAtString = createdAtString
            self.createdAt = Date(dateString: createdStr)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        if let name = aDecoder.decodeObject(forKey: "nameOfGroup") as? String{
        self.nameOfGroup = name
        }
        if let ID = aDecoder.decodeObject(forKey: "pgID") as? String{
            self.pgid = ID
        }
        if let adID = aDecoder.decodeObject(forKey: "adminID") as? String{
            self.adminID = adID
        }
        if let loc = aDecoder.decodeObject(forKey: "location") as? String{
            self.location = loc
        }
        if let dayMeeting = aDecoder.decodeObject(forKey: "dayOfMeeting") as? String{
            self.dayOfMeeting = dayMeeting
        }
        if let secret = aDecoder.decodeObject(forKey: "secretID") as? String{
            self.secretID = secret
        }
        if let timeMeeting = aDecoder.decodeObject(forKey: "timeOfMeeting") as? Date{
            self.timeOfMeeting = timeMeeting
        }
        if let threads = aDecoder.decodeObject(forKey: "threadIDs") as? [String]{
            self.threadIDs = threads
        }
        if let members = aDecoder.decodeObject(forKey: "memberIDs") as? [String]{
            self.memberIDs = members
        }
        if let dailyActivities = aDecoder.decodeObject(forKey: "dailyActivityIDs") as? [String]{
            self.dailyActivityIDs = dailyActivities
        }
        if let groupRequests = aDecoder.decodeObject(forKey: "groupRequestIDs") as? [String]{
            self.groupRequestIDs = groupRequests
        }
        if let update = aDecoder.decodeObject(forKey: "hasBeenUpdated") as? Bool{
            self.hasBeenUpdated = update
        }
        if let created = aDecoder.decodeObject(forKey: "createdAt") as? Date{
            self.createdAt = created
        }
    }
    
    func encode(with aCoder: NSCoder) {
        if let name = self.nameOfGroup {
            aCoder.encode(name, forKey: "nameOfGroup")
        }
        if let ID = self.pgid {
            aCoder.encode(ID, forKey: "pgID")
        }
        if let adID = self.adminID {
            aCoder.encode(adID, forKey: "adminID")
        }
        if let loc = self.location {
            aCoder.encode(loc, forKey: "location")
        }
        if let dayMeeting = self.dayOfMeeting {
            aCoder.encode(dayMeeting, forKey: "dayOfMeeting")
        }
        if let secret = self.secretID {
            aCoder.encode(secret, forKey: "secretID")
        }
        if let timeMeeting = self.timeOfMeeting {
            aCoder.encode(timeMeeting, forKey: "timeOfMeeting")
        }
        if let threads = self.threadIDs {
            aCoder.encode(threads, forKey: "threadIDs")
        }
        if let members = self.memberIDs {
            aCoder.encode(members, forKey: "memberIDs")
        }
        if let dailyActivities = self.dailyActivityIDs {
            aCoder.encode(dailyActivities, forKey: "dailyActivityIDs")
        }
        if let groupRequests = self.groupRequestIDs {
            aCoder.encode(groupRequests, forKey: "groupRequestIDs")
        }
        if let created = self.createdAt {
            aCoder.encode(created, forKey: "createdAt")
        }
        aCoder.encode(hasBeenUpdated, forKey: "hasBeenUpdated")
    }
    
    func getPropertyPackageCreatePrivateGroup() -> [String: Any]{
        var properties = [String: Any]()
        properties["type"] = "PrivateGroup"
        properties["threadIDs"] = [String]()
        properties["memberIDs"] = [String]()
        properties["groupRequestIDs"] = [String]()
        properties["dailyActivityIDs"] = [String]()
        
        if let created = self.createdAtString{
            properties["createdAt"] = created
        }
        if let secret = self.secretID{
        properties["secretID"] = secret
        }
        if let adminID = self.adminID {
            properties["adminID"] = adminID
        }
        if let nameOfGroup = self.nameOfGroup {
            properties["nameOfGroup"] = nameOfGroup
        }
        if let location = self.location {
            properties["location"] = location
        }
        if let dayOfMeeting = self.dayOfMeeting {
            properties["dayOfMeeting"] = dayOfMeeting
        }
        if let secretID = self.secretID {
            properties["secretID"] = secretID
        }
        if let timeMeetingStr = self.timeOfMeetingString {
            properties["timeOfMeeting"] = timeMeetingStr
        }
        return properties
    }
}
