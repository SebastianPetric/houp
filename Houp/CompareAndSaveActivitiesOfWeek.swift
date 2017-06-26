//
//  CompareAndSaveActivitiesOfWeek.swift
//  Houp
//
//  Created by Sebastian on 26.06.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension TempStorageAndCompare{

    //---------------------------------------------------------------------------------------
    // Hier werden neue Aktivitäten der Aktuellen Woche verglichen, und gespeichert falls sich was geändert hat etc
    //---------------------------------------------------------------------------------------
    
    func compareAndSaveActivitiesOfCurrentWeek(currentActivities: [Activity]){
        if (getActiveActivitiesOfCurrentWeek().count != 0) {
            var oldList: [Activity] = getActiveActivitiesOfCurrentWeek()
            
            for item in oldList{
                if(!currentActivities.contains(item)){
                    deleteActivityOfCurrentWeek(activity: item)
                    oldList = getActiveActivitiesOfCurrentWeek()
                }
            }
            
            for activity in currentActivities{
                if let index = oldList.index(where: { (item) -> Bool in
                    item.aid == activity.aid
                }){
                    // check if revision changed, if yes then hasbeenupdated = true
                    if(oldList[index].rev != activity.rev){
                        if(oldList[index].timeObject != activity.timeObject){
                            print("Notifications müssen angepasst werden, und die Kalender App muss aktualisiert werden")
                        }
                        activity.hasBeenUpdated = true
                        oldList[index] = activity
                        saveActivityListCurrentWeek(activityList: oldList)
                        
                    }
                }else{
                    activity.hasBeenUpdated = true
                    oldList.append(activity)
                    saveActivityListCurrentWeek(activityList: oldList)
                }
            }
        }else{
            saveActivityListCurrentWeek(activityList: currentActivities)
        }
    }
    
    func getActiveActivitiesOfCurrentWeek() -> [Activity]{
        var oldActivitiesList: [Activity] = [Activity]()
        var newList: [Activity] = [Activity]()
        if let oldList  = self.userDefaults.object(forKey: "activitiesOfCurrentWeek\(getUserID())") as? Data{
            oldActivitiesList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [Activity]
            newList = oldActivitiesList
        }
        return newList
    }
    
    func getActiveActivityOfCurrentWeek(activityID: String) -> Activity?{
        var oldActivitiesList: [Activity] = [Activity]()
        if let oldList  = self.userDefaults.object(forKey: "activitiesOfCurrentWeek\(getUserID())") as? Data{
            oldActivitiesList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [Activity]
            for activity in oldActivitiesList{
                if(activity.aid == activityID){
                    return activity
                }
            }
        }
        return nil
    }
    
    
    func deleteActivityOfCurrentWeek(activity: Activity){
        var oldActivitiesList: [Activity] = [Activity]()
        var newList: [Activity] = [Activity]()
        if let oldList  = self.userDefaults.object(forKey: "activitiesOfCurrentWeek\(getUserID())") as? Data{
            oldActivitiesList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [Activity]
            if let index = oldActivitiesList.index(where: { (item) -> Bool in
                item.aid == activity.aid
            }){
                oldActivitiesList.remove(at: index)
                newList = sortActivitiesForWeek(activities: oldActivitiesList)
            }
        }
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: newList)
        self.userDefaults.set(encodedData, forKey: "activitiesOfCurrentWeek\(getUserID())")
        self.userDefaults.synchronize()
    }
    
    func deleteFirstItemOfCurrentWeek(){
        var oldActivitiesList: [Activity] = [Activity]()
        var newList: [Activity] = [Activity]()
        if let oldList  = self.userDefaults.object(forKey: "activitiesOfCurrentWeek\(getUserID())") as? Data{
            oldActivitiesList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [Activity]
            oldActivitiesList.removeFirst()
            newList = oldActivitiesList
        }
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: newList)
        self.userDefaults.set(encodedData, forKey: "activitiesOfCurrentWeek\(getUserID())")
        self.userDefaults.synchronize()
    }
    
    func deleteAllActivitiesForCurrentWeek(){
        var oldActivitiesList: [Activity] = [Activity]()
        let newList: [Activity] = [Activity]()
        if let oldList  = self.userDefaults.object(forKey: "activitiesOfCurrentWeek\(getUserID())") as? Data{
            oldActivitiesList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [Activity]
            if(oldActivitiesList.count != 0){
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: newList)
                self.userDefaults.set(encodedData, forKey: "activitiesOfCurrentWeek\(getUserID())")
                self.userDefaults.synchronize()
            }
        }
    }
    
    
    func sortActivitiesForWeek(activities: [Activity]) -> [Activity]{
        var oldActivitiesList: [Activity] = activities
        if(oldActivitiesList.count > 1){
            oldActivitiesList.sort(by:
                { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedAscending }
            )
        }
        return oldActivitiesList
    }
    
    func saveActivityListCurrentWeek(activityList: [Activity]){
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: sortActivitiesForWeek(activities: activityList))
        self.userDefaults.set(encodedData, forKey: "activitiesOfCurrentWeek\(getUserID())")
        self.userDefaults.synchronize()
    }
    
    func getActivitiesOfGroup(groupID: String) -> [Activity]{
        var oldActivitiesList: [Activity] = [Activity]()
        var newList: [Activity] = [Activity]()
        if let oldList  = self.userDefaults.object(forKey: "activitiesOfUser\(getUserID())") as? Data{
            oldActivitiesList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [Activity]
            for activity in oldActivitiesList{
                if(!activity.isInProcess){
                    if let activityGroupID = activity.groupID{
                        if(activityGroupID == groupID){
                            newList.append(activity)
                        }
                    }
                }
            }
            newList = sortActivities(activities: newList)
        }
        return newList
    }
    
    func saveActivityNotificationID(activityID: String, notificationID: String){
        var oldActivitiesList: [Activity] = [Activity]()
        if let oldList  = self.userDefaults.object(forKey: "activitiesOfCurrentWeek\(getUserID())") as? Data{
            oldActivitiesList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [Activity]
            
            if let index = oldActivitiesList.index(where: { (item) -> Bool in
                item.aid == activityID
            }){
                oldActivitiesList[index].notificationID = notificationID
            }
            saveActivityListCurrentWeek(activityList: oldActivitiesList)
        }
    }
    
    func getActivityNotificationID(activityID: String) -> String?{
        var oldActivitiesList: [Activity] = [Activity]()
        if let oldList  = self.userDefaults.object(forKey: "activitiesOfCurrentWeek\(getUserID())") as? Data{
            oldActivitiesList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [Activity]
            for activity in oldActivitiesList{
                if(activity.aid == activityID){
                    return activity.notificationID
                }
            }
        }
        return nil
    }
    
    
    //---------------------------------------------------------------------------------------
    //---------------------------------------------------------------------------------------
}

