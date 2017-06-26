//
//  CompareAndSaveUser.swift
//  Houp
//
//  Created by Sebastian on 26.06.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension TempStorageAndCompare{

    //---------------------------------------------------------------------------------------
    // Hier wird der User verglichen, und gespeichert falls sich was geändert hat etc
    //---------------------------------------------------------------------------------------
    
    func compareAndSaveUsers(user: UserObject){
        if (getUserData().count != 0) {
            var oldList: [UserObject] = getUserData()
            if let index = oldList.index(where: { (item) -> Bool in
                item.uid == user.uid
            }){
                // check if revision changed, if yes then hasbeenupdated = true
                if(oldList[index].rev != user.rev){
                    checkTopicGroupsOfUser(oldGroups: oldList[index], newGroups: user, tempList: oldList, index: index)
                }else{
                    groupsChangedOnDB(groupIDs: user.groupIDs!)
                }
            }else{
                oldList.append(user)
                saveUser(users: oldList)
                self.tempGroupList = user.groupIDs!
                groupsChangedOnDB(groupIDs: user.groupIDs!)
            }
        }else{
            saveUser(users: [user])
            self.tempGroupList = user.groupIDs!
            groupsChangedOnDB(groupIDs: user.groupIDs!)
        }
    }
    
    func getUserData() -> [UserObject]{
        var oldUserList: [UserObject] = [UserObject]()
        if let oldList  = self.userDefaults.object(forKey: "userObjectsSync\(getUserID())") as? Data{
            oldUserList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [UserObject]
        }
        return oldUserList
    }
    
    func saveUser(users: [UserObject]){
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: users)
        self.userDefaults.set(encodedData, forKey: "userObjectsSync\(getUserID())")
        self.userDefaults.synchronize()
    }
    
    func checkTopicGroupsOfUser(oldGroups: UserObject, newGroups: UserObject, tempList: [UserObject], index: Int){
        var tempUserList: [UserObject] = [UserObject]()
        for groupID in oldGroups.groupIDs! {
            if(!(newGroups.groupIDs?.contains(groupID))!) {
                deleteGroup(groupID: groupID)
            }
        }
        
        for groupID in newGroups.groupIDs! {
            if(!(oldGroups.groupIDs?.contains(groupID))!) {
                self.tempGroupList = newGroups.groupIDs!
            }
        }
        
        //        for activityID in newGroups.dailyFormIDs! {
        //            if(!(oldGroups.dailyFormIDs?.contains(activityID))!) {
        //                self.tempActivityIDList = newGroups.dailyFormIDs!
        //            }
        //        }
        
        tempUserList = tempList
        tempUserList[index] = newGroups
        
        saveUser(users: tempUserList)
        
        groupsChangedOnDB(groupIDs: self.tempGroupList)
    }
    
    //wenn sich was beim User verändert (er in einer neuen Gruppe Mitglied geworden ist) werden die Queries neu aufgebaut,
    //sodass die neue gruppe auch nach neuen Einträgen abgefragt werden kann
    func groupsChangedOnDB(groupIDs: [String]){
        if(liveQueryGroups != nil){
            self.liveQueryGroups?.removeObserver(self, forKeyPath: "rows")
        }
        if(groupIDs.count != 0){
            getTopicGroups(groupIDs: groupIDs)
        }else{
            liveQueryGroups = nil
            self.privateGroupCollectionDelegate?.privateGroupsCollection.reloadData()
        }
        
        if(liveQueryPrivateThreads != nil){
            self.liveQueryPrivateThreads?.removeObserver(self, forKeyPath: "rows")
        }
        if(groupIDs.count != 0){
            getPrivateGroupsTopicThreads(groupIDs: groupIDs)
        }else{
            liveQueryPrivateThreads = nil
            self.privateGroupCollectionDelegate?.privateGroupsCollection.reloadData()
            self.privateGroupsWithThreadsDelegate?.threadsCollectionView.reloadData()
        }
        if(liveQueryInactiveActivities != nil){
            self.liveQueryInactiveActivities?.removeObserver(self, forKeyPath: "rows")
        }
        if(groupIDs.count != 0){
            getTopicInactiveActivitiesOfGroups(groupIDs: groupIDs)
        }else{
            liveQueryInactiveActivities = nil
            self.activitiesInPrivateGroupDelegate?.activityCollectionView.reloadData()
        }
    }
    
    func getUserID() -> String{
        return self.userID!
    }
    
    func isUserAdmin(id: String) -> Bool{
        return getUserID() == id
    }
    //---------------------------------------------------------------------------------------
    //---------------------------------------------------------------------------------------
}
