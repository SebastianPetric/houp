//
//  CompareAndSaveGroupActivities.swift
//  Houp
//
//  Created by Sebastian on 26.06.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension TempStorageAndCompare{

    //---------------------------------------------------------------------------------------
    // Hier werden neue Aktivitäten verglichen, und gespeichert falls sich was geändert hat etc
    //---------------------------------------------------------------------------------------
    
    func compareAndSaveActivities(activity: Activity){
        if (getAllActivities().count != 0) {
            var oldList: [Activity] = getAllActivities()
            if let index = oldList.index(where: { (item) -> Bool in
                item.aid == activity.aid
            }){
                // check if revision changed, if yes then hasbeenupdated = true
                if(oldList[index].rev != activity.rev){
                    activity.hasBeenUpdated = true
                    oldList[index] = activity
                    self.activityWithCommentsDelegate?.activityObject = activity
                    saveActivityList(activityList: oldList)
                }
            }else{
                activity.hasBeenUpdated = true
                oldList.append(activity)
                saveActivityList(activityList: oldList)
            }
        }else{
            saveActivityList(activityList: [activity])
        }
    }
    
    func getAllActivities() -> [Activity]{
        var oldActivitiesList: [Activity] = [Activity]()
        if let oldList  = self.userDefaults.object(forKey: "activitiesOfUser\(getUserID())") as? Data{
            oldActivitiesList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [Activity]
        }
        return oldActivitiesList
    }
    
    func sortActivities(activities: [Activity]) -> [Activity]{
        var oldActivitiesList: [Activity] = activities
        if(oldActivitiesList.count > 1){
            oldActivitiesList.sort(by:
                { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedDescending }
            )
        }
        return oldActivitiesList
    }
    
    func saveActivityList(activityList: [Activity]){
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: sortActivities(activities: activityList))
        self.userDefaults.set(encodedData, forKey: "activitiesOfUser\(getUserID())")
        self.userDefaults.synchronize()
    }
    //---------------------------------------------------------------------------------------
    //---------------------------------------------------------------------------------------
}
