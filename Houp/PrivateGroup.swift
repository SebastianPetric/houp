//
//  PrivateGroup.swift
//  Houp
//
//  Created by Sebastian on 29.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation


class PrivateGroup{

    var pgid: String?
    var adminID: String?
    var nameOfGroup: String?
    var secretID: String?
    var location: String?
    var dayOfMeeting: Int?
    var timeOfMeeting: Date?
    var timeOfMeetingString: String?
    var threadIDs: [String]?
    var memberIDs: [String]?
    var groupRequestIDs: [String]?
    var dailyActivityIDs: [String]?
    
    
    init(pgid: String?, adminID: String?,nameOfGroup: String?,location: String?, dayOfMeeting: Int? ,timeOfMeeting: Date?, secretID: String?, threadIDs: [String]?, memberIDs: [String]?, dailyActivityIDs: [String]?, groupRequestIDs: [String]?) {
     
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
    }
    
    
    func getPropertyPackageCreatePrivateGroup() -> [String: Any]{
        var properties = [String: Any]()
        properties["type"] = "PrivateGroup"
        
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
        if let timeOfMeeting = self.timeOfMeeting {
            properties["timeOfMeeting"] = timeOfMeeting
        }
        if let threadIDs = self.threadIDs {
            properties["threadIDs"] = threadIDs
        }
        if let secretID = self.secretID {
            properties["secretID"] = secretID
        }
        if let memberIDs = self.memberIDs {
            properties["memberIDs"] = memberIDs
        }
        if let dailyActivityIDs = self.dailyActivityIDs {
            properties["dailyActivityIDs"] = dailyActivityIDs
        }
        if let groupRequestIDs = self.groupRequestIDs {
            properties["groupRequestIDs"] = groupRequestIDs
        }
        if let timeMeeting = self.timeOfMeeting {
            properties["timeOfMeeting"] = Date().getFormattedStringFromDate(time: timeMeeting)
        }

        return properties
    }

}
